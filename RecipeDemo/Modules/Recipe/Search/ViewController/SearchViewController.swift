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
    func displaySearchResults(_ recipes: [RecipeViewModel])
    func displaySearchSuggestions(_ suggestions: [String])

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
        reultsTableView.isHidden = true
        searchBar.delegate = self
        interactor?.getSearchSuggestions()
    }
 
    // MARK:- Public Methods
    
    func refreshTableView()
    {
       if reultsTableView.isHidden
       {
        reultsTableView.isHidden = false
       }
        reultsTableView.reloadData()
        view.layoutIfNeeded()
    }

    
    // MARK:- Actions
    
    @IBAction func AllAction(_ sender: Any)
    {
        let searchKeyword = searchBar.text ?? ""
        interactor?.fetchSearchResults(query: searchKeyword, filter: nil)
    }
    
    @IBAction func lowSugarAction(_ sender: Any)
    {
        let searchKeyword = searchBar.text ?? ""
        interactor?.fetchSearchResults(query: searchKeyword, filter: .lowSugar)
    }
    
    @IBAction func ketoAction(_ sender: Any)
    {
        let searchKeyword = searchBar.text ?? ""
        interactor?.fetchSearchResults(query: searchKeyword, filter: .keto)
    }
    
    @IBAction func veganAction(_ sender: Any)
    {
        let searchKeyword = searchBar.text ?? ""
        interactor?.fetchSearchResults(query: searchKeyword, filter: .vegan)
    }
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
    
}


