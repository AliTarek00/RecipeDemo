//
//  SearchViewController.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import UIKit
import SearchTextField

protocol SearchViewProtocol: class
{
    var interactor: SearchInteractorProtocol? { get set }
    var router: SearchRouterProtocol? { get set }

    // Update UI with value returned.
    func displayRecipes(recipes: [RecipeViewModel])
    func displayError(WithMessage message: String)
    //func displayEmptyLabel()
}

class SearchViewController: UIViewController
{

    // MARK:- Outlets
    
    @IBOutlet weak var searchBar: SearchTextField!
    @IBOutlet weak var reultsTableView: UITableView!
    
    // MARK:- Properties
    
    lazy var recipes = [RecipeViewModel]() 
    {
        didSet
        {
            refreshTableView()
        }
    }
    
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
       
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    // MARK:- Private Methods
    
    private func setup()
    {
    }
 
    // MARK:- Public Methods
    
    func refreshTableView()
    {
        reultsTableView.reloadData()
        view.layoutIfNeeded()
    }

    
    // MARK:- Actions
    
    @IBAction func AllAction(_ sender: Any)
    {
        interactor?.fetchSearchResults(query: "chiken", filter: nil, from: <#T##Int#>, to: <#T##Int#>)
    }
    
    @IBAction func lowSugarAction(_ sender: Any)
    {
    }
    
    @IBAction func ketoAction(_ sender: Any)
    {
    }
    
    @IBAction func veganAction(_ sender: Any)
    {
    }
    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController: SearchViewProtocol
{
    func displayRecipes(recipes: [RecipeViewModel])
    {
        self.recipes = recipes
    }
    
    func displayError(WithMessage message: String)
    {
        Helper.instance.showAlert(title: "", message: message, ViewController: self)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        let recipeViewModel = recipes[indexPath.row]
        cell.configure(recipeViewModel)
        
        return cell
    }
}
