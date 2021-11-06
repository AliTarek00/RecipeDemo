//
//  SearchPresenter.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

/*
protocol SearchPresenterProtocol
{
    func interactor(_ interactor: SearchViewModelProtocol, didFetchSearchOrFilterResults results: [Recipe])
    func interactor(_ interactor: SearchViewModelProtocol, didFetchSearchSuggestions suggestions: [String])
    func interactor(_ interactor: SearchViewModelProtocol, didFetchNextPageResults results: [Recipe], indexPaths: [IndexPath])
    func interactor(_ interactor: SearchViewModelProtocol, didFailWith error: Error)
}

class SearchPresenter
{
    // MARK: - Properties

    weak var view: SearchViewProtocol?
}

// MARK: - extending SearchPresenter to implement it's protocol

extension SearchPresenter: SearchPresenterProtocol
{
    // MARK: - Implement UI events handlers (search, filter, nextPage)
    
    func interactor(_ interactor: SearchViewModelProtocol, didFetchSearchOrFilterResults results: [Recipe])
    {
        let recipesViewModels = convertRecipesToSearchResultsViewModels(recipes: results)
        view?.displaySearchOrFilterResults(recipesViewModels)
    }
    
    func interactor(_ interactor: SearchViewModelProtocol, didFetchSearchSuggestions suggestions: [String])
    {
        view?.displaySearchSuggestions(suggestions)
    }
        
    func interactor(_ interactor: SearchViewModelProtocol, didFetchNextPageResults results: [Recipe], indexPaths: [IndexPath])
    {
        let recipesViewModels = convertRecipesToSearchResultsViewModels(recipes: results)
        view?.displayNextPageResults(recipesViewModels, indexPaths: indexPaths)
    }
    
    func interactor(_ interactor: SearchViewModelProtocol, didFailWith error: Error)
    {
        view?.displayError(WithMessage: error.localizedDescription)
    }

    // MARK: -  Helper Methods
    
    private func convertRecipesToSearchResultsViewModels(recipes: [Recipe])-> [SearchResultCellViewModel]
    {
        let resultsViewModels = recipes.compactMap { (recipe) -> SearchResultCellViewModel? in
            let healthLabels = recipe.healthLabels.joined(separator: ", ")
            let viewModel = SearchResultCellViewModel(imageLink: recipe.image, title: recipe.label, source: recipe.source, healthLabels: healthLabels)
            
            return viewModel
        }
        return resultsViewModels
    }
}

*/
