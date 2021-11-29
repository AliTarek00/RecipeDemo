//
//  SearchVCExtensions.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/11/21.
//

import UIKit
import Toast_Swift

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    // Hilper method to hide keyboard
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Navigation

extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.navigateToRecipeDetails()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.searchResults.value.count - 1 {
            viewModel.fetchNextPageForSearchResults()
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        let recipeViewModel = viewModel.getCellViewModel(atIndex: indexPath)
        cell.configure(recipeViewModel)
        
        return cell
    }
}
