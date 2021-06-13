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
    func displaySearchOrFilterResults(_ recipes: [RecipeViewModel])
    func displaySearchSuggestions(_ suggestions: [String])
    func displayNextPageResults(_ recipes: [RecipeViewModel], indexPaths: [IndexPath])
    
    func displayError(WithMessage message: String)
}

class SearchViewController: UIViewController
{
    // MARK:- Outlets
    
    @IBOutlet weak var searchBar: SearchTextField!
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var filterStack: UIStackView!
    
    @IBOutlet weak var allFiletrButton: UIButton!
    @IBOutlet weak var lowSugarFiletrButton: UIButton!
    @IBOutlet weak var ketoFiletrButton: UIButton!
    @IBOutlet weak var veganFiletrButton: UIButton!
    
    // MARK:- Properties
    
    lazy var recipes = [RecipeViewModel]()
    
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
        setSelectedViewAppearnce(For: allFiletrButton)
        configureResultsView(hide: true)
        searchBar.delegate = self
        
        interactor?.fetchSearchSuggestions()
    }
    
    // MARK:- Public Methods
    
    // MARK:- Helper Methods
    
    private func setSelectedViewAppearnce(For button: UIButton)
    {
        button.backgroundColor = .appGreen
        button.setTitleColor(.white, for: .normal)
    }
    
    private func setUnSelectedViewAppearnce(For button: UIButton)
    {
        button.backgroundColor = .white
        button.setTitleColor(.appGreen, for: .normal)
    }
    
    func configureResultsView(hide: Bool)
    {
        filterStack.isHidden = hide
        resultsTableView.isHidden = hide
    }
    
    func refreshTableView()
    {
        configureResultsView(hide: false)
        resultsTableView.reloadData()
        let topRow = IndexPath(row: 0,section: 0)
        resultsTableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    func updateTableView(with indexPaths: [IndexPath])
    {
        configureResultsView(hide: false)
        resultsTableView.performBatchUpdates(
            {
                resultsTableView.setContentOffset(resultsTableView.contentOffset, animated: false)
                resultsTableView.insertRows(at: indexPaths, with: .bottom)
            }, completion: nil)
    }
    
    // MARK:- Actions
    
    @IBAction func AllAction(_ sender: Any)
    {
        setSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: ketoFiletrButton)
        setUnSelectedViewAppearnce(For: veganFiletrButton)
        
        interactor?.filterResults(WithFilter: .all)
    }
    
    @IBAction func lowSugarAction(_ sender: Any)
    {
        setSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: ketoFiletrButton)
        setUnSelectedViewAppearnce(For: veganFiletrButton)
        
        interactor?.filterResults(WithFilter: .lowSugar)
    }
    
    @IBAction func ketoAction(_ sender: Any)
    {
        setSelectedViewAppearnce(For: ketoFiletrButton)
        setUnSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: veganFiletrButton)
        
        interactor?.filterResults(WithFilter: .keto)
    }
    
    @IBAction func veganAction(_ sender: Any)
    {
        setSelectedViewAppearnce(For: veganFiletrButton)
        setUnSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: ketoFiletrButton)
        
        interactor?.filterResults(WithFilter: .vegan)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
    
}


