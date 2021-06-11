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
        interactor?.fetchSearchResults(query: searchKeyword, filter: nil)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: SearchViewProtocol
{
    func displaySearchResults(_ recipes: [RecipeViewModel])
    {
        self.recipes = recipes
    }
    
    func displaySearchSuggestions(_ suggestions: [String])
    {
        searchBar.filterStrings(suggestions)
    }
    
    func displayError(WithMessage message: String)
    {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard recipes.count - indexPath.row == 2 else {
            return
        }
        interactor?.getNextPageForSearchResults()
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
