//
//  RecipeDetailsVCExtensions.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/14/21.
//

import UIKit

// MARK: - UITableViewDelegate

extension RecipeDetailsViewController: RecipeDetailsViewProtocol
{
    func display(_ recipe: RecipeDetailsViewModel)
    {
        recipeImageView.setImage(from: recipe.imageLink)
        recipeTitleLabel.text = recipe.title
        ingrediantsTableView.reloadData()
    }
    
    func openRecipeWebsite(url: URL)
    {
        UIApplication.shared.open(url)
    }
    
    func shareRecipe(url: URL)
    {
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        present(ac, animated: true)
    }
}

extension RecipeDetailsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        self.viewWillLayoutSubviews()
    }
}

// MARK: - UITableViewDataSource

extension RecipeDetailsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return interactor?.recipe.ingredientLines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingrediantCell", for: indexPath) 
        
        let ingrediant = interactor?.recipe.ingredientLines[indexPath.row]
        cell.textLabel?.text = ingrediant
        
        return cell
    }
}
