//
//  SearchBuilder.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

class SearchBuilder {

    class func buildModule(arroundView view:SearchViewProtocol) {
        
        //MARK: Initialise components.
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(searchAPIWorker: SearchAPIWorker(networkManager: RecipeNetworkManager()), suggestionsWorker: SearchSuggestionWorker())
        let router = SearchRouter()
        
        //MARK: link VIP components.
        view.interactor = interactor
        view.router = router
        presenter.view = view
        interactor.presenter = presenter
    }
}
