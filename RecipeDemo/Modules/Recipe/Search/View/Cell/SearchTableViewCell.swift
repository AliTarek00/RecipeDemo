//
//  SearchTableViewCell.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell
{
    // MARK:- Oultets
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    
    // MARK:- Mthods

    func configure(_ recipe: SearchResultCellViewModel) {
        recipeImage.setImage(from: recipe.imageLink, placeholderImage: #imageLiteral(resourceName: "add image"))
        titleLabel.text = recipe.title
        sourceLabel.text = recipe.source
        healthLabel.text = recipe.healthLabels
    }
}
