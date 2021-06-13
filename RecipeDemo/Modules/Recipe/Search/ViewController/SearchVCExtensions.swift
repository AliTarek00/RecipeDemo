//
//  SearchVCExtensions.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/11/21.
//

import UIKit

// MARK: - UITableViewDelegate

extension SearchViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        guard let searchKeyword = textField.text, searchKeyword.isNotEmptyOrSpaces()
        else
        {
            displayError(WithMessage: "Please Enter Valid Sarch Keyword")
            textField.resignFirstResponder()
            return true
        }
        interactor?.search(WithKeyowrd: searchKeyword)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: SearchViewProtocol
{
    func displaySearchResults(_ recipes: [RecipeViewModel], indexPaths: [IndexPath]?)
    {
        self.recipes = recipes
        refreshTableView(with: indexPaths)
    }
    
    func displaySearchSuggestions(_ suggestions: [String])
    {
        // filterStrings is a method responsiple for mange auto suggestions in SearchTextField pod
        searchBar.filterStrings(suggestions)
    }
    
    func displayError(WithMessage message: String)
    {
        configureResultsView(hide: true)
        Helper.instance.showAlert(title: "", message: message, ViewController: self)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        guard indexPath.row ==  recipes.count - 2, tablevi  else {
//            return
//        }
//
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height)
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
