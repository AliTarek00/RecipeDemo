//
//  RecipeDetailsBuilder.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/14/21.
//

import Foundation

class RecipeDetailsBuilder {

    class func buildModule(arroundView view: RecipeDetailsViewController, recipe: Recipe) {
        
        //MARK: Initialise components.
        let presenter = RecipeDetailsPresenter()
        let interactor = RecipeDetailsInteractor(recipe: recipe)
        let router = RecipeDetailsRouter()
        
        //MARK: link VIP components.
        view.interactor = interactor
        view.router = router
        presenter.view = view
        interactor.presenter = presenter
    }
}
