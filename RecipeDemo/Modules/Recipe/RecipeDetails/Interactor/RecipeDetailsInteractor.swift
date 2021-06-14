//
//  RecipeDetailsInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/14/21.
//

import Foundation

protocol RecipeDetailsInteractorProtocol
{
    var recipe: Recipe { get }
    
    func showRecipeInfo()
    func openRecipeWebsite()
    func shareRecipe()
}

class RecipeDetailsInteractor: RecipeDetailsInteractorProtocol
{
    // MARK: - Properties
    
    private(set) var recipe: Recipe
    var presenter: RecipeDetailsPresenterProtocol?
    
    required init(recipe: Recipe)
    {
        self.recipe = recipe
    }
    
    func showRecipeInfo()
    {
        presenter?.interactor(self, didSetRecipeInfo: recipe)
    }
    
    func openRecipeWebsite()
    {
        presenter?.interactor(self, didGetWebsiteLink: recipe.url)
    }
    
    func shareRecipe()
    {
        presenter?.interactor(self, didGetShareLink: recipe.shareAs)
    }
}

