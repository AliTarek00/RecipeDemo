//
//  RecipeDetailsPresenter.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/14/21.
//

import Foundation

protocol RecipeDetailsPresenterProtocol
{
    func interactor(_ interactor: RecipeDetailsInteractorProtocol, didSetRecipeInfo recipe: Recipe)
    func interactor(_ interactor: RecipeDetailsInteractorProtocol, didGetWebsiteLink link: String)
    func interactor(_ interactor: RecipeDetailsInteractorProtocol, didGetShareLink link: String)

}

class RecipeDetailsPresenter
{
    // MARK: - Properties
    
    weak var view: RecipeDetailsViewProtocol?
}

// MARK: - extending RecipeDetailsPresenter to implement it's protocol

extension RecipeDetailsPresenter: RecipeDetailsPresenterProtocol
{
    func interactor(_ interactor: RecipeDetailsInteractorProtocol, didSetRecipeInfo recipe: Recipe)
    {
        let recipeDetailsViewModel = RecipeDetailsViewModel(imageLink: recipe.image, title: recipe.label, url: recipe.url, shareAs: recipe.shareAs, ingredients: recipe.ingredientLines)
        view?.display(recipeDetailsViewModel)
    }
    
    func interactor(_ interactor: RecipeDetailsInteractorProtocol, didGetWebsiteLink link: String)
    {
        if let url = URL(string: link)
        {
            view?.openRecipeWebsite(url: url)
        }
    }
    
    func interactor(_ interactor: RecipeDetailsInteractorProtocol, didGetShareLink link: String)
    {
        if let url = URL(string: link)
        {
            view?.shareRecipe(url: url)
        }
    }
    
}
