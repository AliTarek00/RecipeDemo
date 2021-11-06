//
//  SearchBuilder.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

class SearchBuilder {

    class func buildModule(arroundView view: SearchViewController) {
        
        //MARK: Initialise components.
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(recipeService: RecipeNetworkManager(), suggestionsWorker: SearchSuggestionWorker())
        let router = SearchRouter()
        
        //MARK: link VIP components.
        view.interactor = interactor
        view.router = router
        router.viewController = view
        presenter.view = view
        interactor.presenter = presenter
    }
}
