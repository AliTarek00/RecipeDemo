//
//  SearchPresenter.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol SearchPresenterProtocol
{
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchResults results: [Recipe], indexPaths: [IndexPath]?)
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchSuggestions suggestions: [String])
    func interactor(_ interactor: SearchInteractorProtocol, didFailWith error: Error)
}

class SearchPresenter
{
    // MARK: - Properties

    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
}

// MARK: - extending SearchPresenter to implement it's protocol
extension SearchPresenter: SearchPresenterProtocol
{
    // MARK: - implement UI action handler
    
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchResults results: [Recipe], indexPaths: [IndexPath]?)
    {
        let recipesViewModels = results.compactMap { (recipe) -> RecipeViewModel? in
            let healthLabels = recipe.healthLabels.joined(separator: ", ")
            let viewModel = RecipeViewModel(imageLink: recipe.image, title: recipe.label, source: recipe.source, healthLabels: healthLabels)
            
            return viewModel
        }
        view?.displaySearchResults(recipesViewModels, indexPaths: indexPaths)
    }
    
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchSuggestions suggestions: [String])
    {
        view?.displaySearchSuggestions(suggestions)
    }
    
    
    func interactor(_ interactor: SearchInteractorProtocol, didFailWith error: Error)
    {
        view?.displayError(WithMessage: error.localizedDescription)
    }
}
