//
//  SearchPresenter.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol SearchPresenterProtocol
{
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchOrFilterResults results: [Recipe])
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchSuggestions suggestions: [String])

    func interactor(_ interactor: SearchInteractorProtocol, didFetchNextPageResults results: [Recipe], indexPaths: [IndexPath])

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
    // MARK: - Implement UI events handlers (search, filter, nextPage)
    
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchOrFilterResults results: [Recipe])
    {
        let recipesViewModels = convertRecipesToRecipeViewModels(recipes: results)
        view?.displaySearchOrFilterResults(recipesViewModels)
    }
    
    func interactor(_ interactor: SearchInteractorProtocol, didFetchSearchSuggestions suggestions: [String])
    {
        
        view?.displaySearchSuggestions(suggestions)
    }
        
    func interactor(_ interactor: SearchInteractorProtocol, didFetchNextPageResults results: [Recipe], indexPaths: [IndexPath])
    {
        let recipesViewModels = convertRecipesToRecipeViewModels(recipes: results)
        view?.displayNextPageResults(recipesViewModels, indexPaths: indexPaths)
    }
    
    func interactor(_ interactor: SearchInteractorProtocol, didFailWith error: Error)
    {
        view?.displayError(WithMessage: error.localizedDescription)
    }

    // MARK: -  Helper Methods
    
    private func convertRecipesToRecipeViewModels(recipes: [Recipe])-> [RecipeViewModel]
    {
        let recipesViewModels = recipes.compactMap { (recipe) -> RecipeViewModel? in
            let healthLabels = recipe.healthLabels.joined(separator: ", ")
            let viewModel = RecipeViewModel(imageLink: recipe.image, title: recipe.label, source: recipe.source, healthLabels: healthLabels)
            
            return viewModel
        }
        return recipesViewModels
    }
}
