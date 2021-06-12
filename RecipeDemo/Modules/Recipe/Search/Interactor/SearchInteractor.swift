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
        self.fetchSearchSuggestions()
    }
    
    deinit
    {
        suggestionsWorker.saveSearchSuggestions(suggestions)
    }
    
    // MARK: - Methods
    
    func search(WithKeyowrd query: String)
    {
        let searchKeyword = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard searchKeyword != lastSearchKeyword else { return }
        
        resetPaginationProperties()
        suggestions = suggestionsWorker.addNewSuggestion(searchKeyword)
        
        searchAPIWorker.fetchSearchResults(query: searchKeyword, filter: lastSearchFilter?.rawValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                extractRecipes(fromHits: response.data)
                
            case .failure(let error):
                presenter?.interactor(self, didFailWith: error)
            }
            isAPaginationRequest = false
            lastSearchKeyword = searchKeyword
        }
    }
    
    func filterResults(WithFilter filter: HealthFilter)
    {
        searchAPIWorker.fetchSearchResults(query: lastSearchKeyword, filter: filter.rawValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                extractRecipes(fromHits: response.data)
                
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
        from = to + 1
        to = from + 10
        isAPaginationRequest = true

        searchAPIWorker.fetchSearchResults(query: lastSearchKeyword, filter: lastSearchFilter?.rawValue, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                setInteractorProperties(response: response)
                extractRecipes(fromHits: response.data)
                
            case .failure:
                print("failure in pagination")
                break
            }
            isAPaginationRequest = false
        }
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
