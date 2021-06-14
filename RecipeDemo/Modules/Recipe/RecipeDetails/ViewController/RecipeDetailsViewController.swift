//
//  RecipeDetailsViewController.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/14/21.
//

import UIKit

protocol RecipeDetailsViewProtocol: class
{
    var interactor: RecipeDetailsInteractorProtocol? { get set }
    var router: RecipeDetailsRouterProtocol? { get set }

    // Update UI with value returned.
    func display(_ recipe: RecipeDetailsViewModel)
    
    func openRecipeWebsite(url: URL)
    func shareRecipe(url: URL)
}

class RecipeDetailsViewController: UIViewController
{
    // MARK:- Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingrediantsTableView: UITableView!
    @IBOutlet weak var openRecipeWebsite: UIButton!

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK:- Properties
    
    var interactor: RecipeDetailsInteractorProtocol?
    var router: RecipeDetailsRouterProtocol?

    // MARK: View Controller Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        interactor?.showRecipeInfo()
    }
    
    override func viewWillLayoutSubviews()
    {
        super.updateViewConstraints()
        tableViewHeight?.constant = ingrediantsTableView.contentSize.height
    }
    
    // MARK:- Actions
    
    @IBAction func openRecipeWebsiteAction(_ sender: Any)
    {
        interactor?.openRecipeWebsite()
    }
    
    @IBAction func shareRecipeAction(_ sender: Any)
    {
        interactor?.shareRecipe()
    }
}
