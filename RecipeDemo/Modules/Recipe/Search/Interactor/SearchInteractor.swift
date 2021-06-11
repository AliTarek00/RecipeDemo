//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol SearchInteractorProtocol
{
    func fetchSearchResults(query: String, filter: HealthFilter?)
    func getNextPageForSearchResults()
    func getSearchSuggestions()
}

class SearchInteractor: SearchInteractorProtocol
{
    // MARK: - Properties
    
    private lazy var from: Int = 0
    private lazy var to: Int = 10
    private lazy var totalItems: Int = 0
    private lazy var hasMore: Bool = true
    private lazy var hits: [Hit] = [Hit]()
    private lazy var suggestions: [String] = [String]()
    
    lazy var isLoading = false
    lazy var isAPaginationRequest = false
    lazy var lastSearchKeyword: String = ""
    var lastSearchFilter: HealthFilter?
    
    private let networkManager: RecipeNetworkable
    private let suggestionsWorker: SearchSuggestionWorkerProtocol
    var presenter: SearchPresenterProtocol?
    
    required init(networkManager: RecipeNetworkable, suggestionsWorker: SearchSuggestionWorkerProtocol)
    {
        self.networkManager = networkManager
        self.suggestionsWorker = suggestionsWorker
        self.fetchSearchSuggestions()
    }
    
    deinit
    {
        suggestionsWorker.saveSearchSuggestions(suggestions)
    }
    
    // MARK: - Methods
    
    func fetchSearchResults(query: String, filter: HealthFilter? = nil)
    {
        let searchKeyword = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard (searchKeyword != lastSearchKeyword && !isAPaginationRequest) else
        {
            return
        }
        
        let filterValue = filter == .all ? nil : filter?.rawValue
        isLoading = true
        resetPaginationProperties()
        suggestions = suggestionsWorker.addNewSuggestion(searchKeyword)
        
        networkManager.search(query: searchKeyword, filter: filterValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                extractRecipes(fromHits: response.data)
                
            case .failure(let error):
                presenter?.interactor(self, didFailWith: error)
            }
            isLoading = false
            isAPaginationRequest = false
            lastSearchKeyword = query
            lastSearchFilter = filter
        }
    }
    
    func getNextPageForSearchResults()
    {
        guard hasMore, !isLoading, from + to < totalItems else { return }
        self.from = self.to + 1
        self.to = from + 10
        isAPaginationRequest = true
        fetchSearchResults(query: lastSearchKeyword, filter: lastSearchFilter)
    }
    
    func getSearchSuggestions()
    {
        presenter?.interactor(self, didFetchSearchSuggestions: suggestions)
    }
    
    private func fetchSearchSuggestions()
    {
        suggestionsWorker.fetchSearchSuggestions
        { [unowned self] (result: Result<[String], Error>) in
            switch result
            {
            case .success(let suggestions):
                self.suggestions = suggestions
                
            case .failure(let error):
                presenter?.interactor(self, didFailWith: error)
            }
        }
    }
    
    private func resetPaginationProperties()
    {
        from = 0
        to = 10
        hasMore = true
        totalItems = 0
    }
    
    private func setInteractorProperties(response: PagingResponse<Hit>)
    {
        guard let from = response.from, let to = response.to, let more = response.more, let totalItems = response.totalItems, let hits = response.data else
        {
            presenter?.interactor(self, didFailWith: SearchError.emptySearch)
            return
        }
        
        self.from = from
        self.to = to
        self.hasMore = more
        self.totalItems = totalItems
        
        if isAPaginationRequest
        {
            self.hits.append(contentsOf: hits)
        }
        else
        {
            self.hits = hits
        }
    }
    
    private func extractRecipes(fromHits hits: [Hit]?)
    {
        guard let hits = hits else
        {
            presenter?.interactor(self, didFailWith: SearchError.emptySearch)
            return
        }
        
        let recipes = hits.compactMap{ $0.recipe }
        presenter?.interactor(self, didFetchSearchResults: recipes)
    }
}
