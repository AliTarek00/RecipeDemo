//
//  SearchViewController.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import UIKit
import SearchTextField
import Combine

protocol SearchViewProtocol: AnyObject {
    var viewModel: SearchViewModelProtocol! { get set }
    var router: SearchRouterProtocol! { get set }
    
    // Update UI with value returned.
    func displayError(WithMessage message: String)
}

class SearchViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: SearchTextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var filterStack: UIStackView!
    
    @IBOutlet weak var allFiletrButton: UIButton!
    @IBOutlet weak var lowSugarFiletrButton: UIButton!
    @IBOutlet weak var ketoFiletrButton: UIButton!
    @IBOutlet weak var veganFiletrButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: SearchViewModelProtocol!
    var router: SearchRouterProtocol!
    
    private lazy var subscribtions = Set<AnyCancellable>()
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        setSelectedViewAppearnce(For: allFiletrButton)
        configureResultsView(hide: true)
        setupTableView()
        setupSearchBar()
        setupGestures()
        bindUIWithViewMode()
    }
    
    private func bindUIWithViewMode() {
        searchBar
            .textPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                self?.viewModel?.searchKeyword.send(text)
            })
            .store(in: &subscribtions)
        
        viewModel?.searchResults
            .receive(on: DispatchQueue.main)
            .print()
            .filter{!$0.isEmpty}
            .sink(receiveValue: { [weak self] _ in
                self?.refreshSearchOrFilterResults()
            })
            .store(in: &subscribtions)
        
        viewModel?.nextPageResults
            .receive(on: DispatchQueue.main)
            .filter{!$0.isEmpty}
            .sink(receiveValue: { [weak self] _ in
                self?.refreshTableView()
            })
            .store(in: &subscribtions)
        
        viewModel?.searchSuggestions
            .receive(on: DispatchQueue.main)
            .filter{!$0.isEmpty}
            .sink(receiveValue: { [weak self] suggestions in
                self?.searchBar.filterStrings(suggestions)
            })
            .store(in: &subscribtions)
        
        viewModel?.errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink(receiveValue: { [weak self] message in
                self?.displayError(WithMessage: message)
            })
            .store(in: &subscribtions)
    }
    
    private func setupTableView() {
        resultsTableView.tableFooterView = UIView() // this to remove empty cells in case samll number of results
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.startVisible = true
        searchBar.theme.bgColor = .white
        searchBar.theme.font = .systemFont(ofSize: 15)
        searchBar.theme.cellHeight = 40
        searchBar.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
    }
    
    private func setupGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        tap.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tap)
    }
            
    private func setSelectedViewAppearnce(For button: UIButton) {
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
    }
    
    private func setUnSelectedViewAppearnce(For button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
    }
    
    private func refreshSearchOrFilterResults() {
        refreshTableView()
        let topRow = IndexPath(row: 0,section: 0)
        resultsTableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    private func refreshTableView() {
        configureResultsView(hide: false)
        resultsTableView.reloadData()
    }
    
    private func configureResultsView(hide: Bool) {
        filterStack.isHidden = hide
        resultsTableView.isHidden = hide
    }
    
    private func displayError(WithMessage message: String) {
        resultsTableView.isHidden = true
        self.view.makeToast(message)
    }
        
    // MARK: - Actions
    
    @IBAction func AllAction(_ sender: Any) {
        setSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: ketoFiletrButton)
        setUnSelectedViewAppearnce(For: veganFiletrButton)
        
        viewModel?.searchFilter.value = .all
    }
    
    @IBAction func lowSugarAction(_ sender: Any) {
        setSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: ketoFiletrButton)
        setUnSelectedViewAppearnce(For: veganFiletrButton)
        
        viewModel?.searchFilter.value = .lowSugar
    }
    
    @IBAction func ketoAction(_ sender: Any) {
        setSelectedViewAppearnce(For: ketoFiletrButton)
        setUnSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: veganFiletrButton)
        
        viewModel?.searchFilter.value = .keto
    }
    
    @IBAction func veganAction(_ sender: Any) {
        setSelectedViewAppearnce(For: veganFiletrButton)
        setUnSelectedViewAppearnce(For: allFiletrButton)
        setUnSelectedViewAppearnce(For: lowSugarFiletrButton)
        setUnSelectedViewAppearnce(For: ketoFiletrButton)
        
        viewModel?.searchFilter.value = .vegan
    }
}


