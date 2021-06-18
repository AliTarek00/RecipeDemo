//
//  SearchVCExtensions.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/11/21.
//

import UIKit
import Toast_Swift

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && string == " "
        { // prevent space on first character
            return false
        }
        
        if textField.text?.last == " " && string == " "
        { // allowed only single space
            return false
        }

        if string == " " { return true } // now allowing space between name

        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil
        {
            return false
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        guard let searchKeyword = textField.text, searchKeyword.isNotEmptyOrSpaces() else
        {
            displayError(WithMessage: "Please Enter Valid Sarch Keyword")
            textField.resignFirstResponder()
            return true
        }
        interactor?.search(WithKeyowrd: searchKeyword)
        textField.resignFirstResponder()
        return true
    }
    
    // Hilper method to hide keyboard
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer)
    {
        searchBar.resignFirstResponder()
    }
}

// MARK: - SearchViewProtocol

extension SearchViewController: SearchViewProtocol
{
    func displaySearchOrFilterResults(_ recipes: [SearchResultCellViewModel])
    {
        self.recipes = recipes
        refreshTableView()
        let topRow = IndexPath(row: 0,section: 0)
        resultsTableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    func displayNextPageResults(_ recipes: [SearchResultCellViewModel], indexPaths: [IndexPath])
    {
        self.recipes = recipes
        refreshTableView()
    }
    
    func displaySearchSuggestions(_ suggestions: [String])
    {
        // filterStrings is a method responsiple for mange auto suggestions in SearchTextField pod
        searchBar.filterStrings(suggestions)
    }
    
    func displayError(WithMessage message: String)
    {
        resultsTableView.isHidden = true
        self.view.makeToast(message)
    }
}

// MARK: - Navigation

extension SearchViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        router?.passDataToNextScene(segue)
    }

}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        router?.navigateToRecipeDetails()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == recipes.count - 1
        {
            interactor?.fetchNextPageForSearchResults()
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        let recipeViewModel = recipes[indexPath.row]
        cell.configure(recipeViewModel)
        
        return cell
    }
}
