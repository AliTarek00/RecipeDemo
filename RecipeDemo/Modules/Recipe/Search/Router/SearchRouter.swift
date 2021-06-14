//
//  Searchrouter.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import UIKit

protocol SearchRouterProtocol
{
    func navigateToRecipeDetails()
    func passDataToNextScene(_ segue: UIStoryboardSegue)
}

class SearchRouter: SearchRouterProtocol
{
    weak var viewController: SearchViewController?
    
    // MARK: Navigation
    
    func navigateToRecipeDetails()
    {
        viewController?.performSegue(withIdentifier: RecipeSegues.recipeDetails.rawValue, sender: viewController)
    }
    
    // MARK: Passing data
    
    func passDataToNextScene(_ segue: UIStoryboardSegue)
    {
        // tell the router which scenes it can communicate with
        if segue.identifier == RecipeSegues.recipeDetails.rawValue
        {
            passDataToRecipeDetails(segue)
        }
    }
    
    private func passDataToRecipeDetails(_ segue: UIStoryboardSegue)
    {
        if let selectedIndexPath = viewController?.resultsTableView.indexPathForSelectedRow,
             let selectedRecipe = viewController?.interactor?.searchResults[selectedIndexPath.row],
                let recipeDetailsViewController = segue.destination as? RecipeDetailsViewController
        {
            RecipeDetailsBuilder.buildModule(arroundView: recipeDetailsViewController, recipe: selectedRecipe)
        }
    }
}
