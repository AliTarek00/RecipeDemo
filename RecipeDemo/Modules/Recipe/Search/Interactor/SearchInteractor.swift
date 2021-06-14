//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol SearchInteractorProtocol
{
    func search(WithKeyowrd query: String)
    func filterResults(WithFilter filter: HealthFilter)
    func fetchNextPageForSearchResults()
    func fetchSearchSuggestions()
    func saveSearchSuggestions()
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
    private lazy var indexPathsToReload: [IndexPath] = [IndexPath]()

    lazy var isAPaginationRequest = false
    lazy var lastSearchKeyword: String = ""
    var lastSearchFilter: HealthFilter?
    
    private let searchAPIWorker: SearchAPIWorkerProtocol
    private let suggestionsWorker: SearchSuggestionWorkerProtocol

    var presenter: SearchPresenterProtocol?
    
    required init(searchAPIWorker: SearchAPIWorkerProtocol, suggestionsWorker: SearchSuggestionWorkerProtocol)
    {
        self.searchAPIWorker = searchAPIWorker
        self.suggestionsWorker = suggestionsWorker
        self.getSearchSuggestions()
    }
    
    // MARK: - Methods
    
    func search(WithKeyowrd query: String)
    {
        let searchKeyword = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard searchKeyword != lastSearchKeyword else { return }
        
        if !suggestions.contains(searchKeyword)
        {
            suggestions = suggestionsWorker.addNewSuggestion(searchKeyword)
            presenter?.interactor(self, didFetchSearchSuggestions: suggestions)
        }
        
        resetPaginationProperties()

        searchAPIWorker.fetchSearchResults(query: searchKeyword, filter: lastSearchFilter?.rawValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                
            case .failure(let error):
                presenter?.interactor(self, didFailWith: error)
            }
            isAPaginationRequest = false
            lastSearchKeyword = searchKeyword
        }
    }
    
    func filterResults(WithFilter filter: HealthFilter)
    {
        guard filter != lastSearchFilter else { return }
        let filterRawValue = filter == .all ? nil : filter.rawValue
        resetPaginationProperties()
        
        searchAPIWorker.fetchSearchResults(query: lastSearchKeyword, filter: filterRawValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                
            case .failure(let error):
                presenter?.interactor(self, didFailWith: error)
            }
            isAPaginationRequest = false
            lastSearchFilter = filter
        }
    }
    
    func fetchNextPageForSearchResults()
    {
        guard hasMore, !searchAPIWorker.isLoading, from + to < totalItems else { return }
        from = to
        to = (from + 10) > totalItems ? (totalItems - from) : (from + 10)
        isAPaginationRequest = true

        searchAPIWorker.fetchSearchResults(query: lastSearchKeyword, filter: lastSearchFilter?.rawValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                
            case .failure:
                print("failure in pagination")
                break
            }
            isAPaginationRequest = false
        }
    }
    
    func saveSearchSuggestions()
    {
        suggestionsWorker.saveSearchSuggestions(suggestions)
    }

    func fetchSearchSuggestions()
    {
        presenter?.interactor(self, didFetchSearchSuggestions: suggestions)
    }
    
    private func getSearchSuggestions()
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
            presenter?.interactor(self, didFailWith: SearchError.invalidSearchKeyowrd)
            return
        }
        
        guard !hits.isEmpty else
        {
            // don't show alert error ife in a pagination request and there is no more items
            if isAPaginationRequest { return }
            
            presenter?.interactor(self, didFailWith: SearchError.emptySearch)
            return
        }
        
        // we should calculate IndexPaths ForNewRows before update from and to values
        self.indexPathsToReload = calculateIndexPathsForNewRows()
        self.from = from
        self.to = to
        self.hasMore = more
        self.totalItems = totalItems
        
        if isAPaginationRequest
        {
            self.hits.append(contentsOf: hits)
            let recipes = getRecipesFromHits()
            presenter?.interactor(self, didFetchNextPageResults: recipes, indexPaths: indexPathsToReload)
        }
        else
        {
            self.hits = hits
            let recipes = getRecipesFromHits()
            presenter?.interactor(self, didFetchSearchOrFilterResults: recipes)
        }
    }
    
    private func getRecipesFromHits()-> [Recipe]
    {
        return hits.compactMap{ $0.recipe }
    }
    
    private func calculateIndexPathsForNewRows()-> [IndexPath]
    {
        return (from..<to).map { IndexPath(row: $0, section: 0) }
    }
}
