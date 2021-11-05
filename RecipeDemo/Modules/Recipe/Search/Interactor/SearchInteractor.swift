//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation
import Combine

protocol SearchInteractorProtocol {
    var searchResults: CurrentValueSubject<[Recipe],Error> { get }

    func search(WithKeyowrd query: String)
    func filterResults(WithFilter filter: HealthFilter)
    func fetchNextPageForSearchResults()
    func fetchSearchSuggestions()
    func saveSearchSuggestions()
}

class SearchInteractor: SearchInteractorProtocol {
    
    // MARK: - Properties

    private lazy var from: Int = 0
    private lazy var to: Int = 10
    private lazy var totalItems: Int = 0
    private lazy var hasMore: Bool = true
    private lazy var suggestions: [String] = [String]()
    private lazy var indexPathsToReload: [IndexPath] = [IndexPath]()
    private (set) lazy var searchResults = CurrentValueSubject<[Recipe],Error>([Recipe]())
    lazy var isAPaginationRequest = false
    lazy var lastSearchKeyword: String = ""
    var lastSearchFilter: HealthFilter?
    private (set) lazy var isLoading: Bool = false
    
    private let recipeService: RecipeNetworkable
    private let suggestionsWorker: SearchSuggestionWorkerProtocol
    
    private lazy var subscriptions = Set<AnyCancellable>()


    var presenter: SearchPresenterProtocol?
    
    required init(recipeService: RecipeNetworkable, suggestionsWorker: SearchSuggestionWorkerProtocol) {
        self.recipeService = recipeService
        self.suggestionsWorker = suggestionsWorker
        self.getSearchSuggestions()
    }
    
    // MARK: - Methods
    
    func search(WithKeyowrd query: String) {
        let searchKeyword = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard searchKeyword != lastSearchKeyword else { return }
        
        if !suggestions.contains(searchKeyword) {
            suggestions = suggestionsWorker.addNewSuggestion(searchKeyword)
            presenter?.interactor(self, didFetchSearchSuggestions: suggestions)
        }
        
        resetPaginationProperties()
        isLoading = true
        
        recipeService
            .search(query: searchKeyword, filter: lastSearchFilter?.rawValue, from: from, to: to)
            .sink { [weak self] (completion) in
                self?.isLoading = false
                self?.isAPaginationRequest = false
                self?.lastSearchKeyword = searchKeyword
                
                if case .failure(let error) = completion {
                    self?.searchResults.send(completion: .failure(error))
                }
                
            } receiveValue: { [weak self] (response) in
                self?.setInteractorProperties(response: response)
            }
            .store(in: &subscriptions)
    }
    
    func filterResults(WithFilter filter: HealthFilter) {
        guard filter != lastSearchFilter else { return }
        let filterRawValue = filter == .all ? nil : filter.rawValue
        resetPaginationProperties()
        isLoading = false

        recipeService
            .search(query: lastSearchKeyword, filter: filterRawValue, from: from, to: to)
            .sink { [weak self] (completion) in
                self?.isLoading = false
                self?.isAPaginationRequest = false
                self?.lastSearchFilter = filter
                
                if case .failure(let error) = completion {
                    self?.searchResults.send(completion: .failure(error))
                }
                
            } receiveValue: { [weak self] (response) in
                self?.setInteractorProperties(response: response)
            }
            .store(in: &subscriptions)
    }
    
    func fetchNextPageForSearchResults() {
        guard hasMore, !isLoading, from + to < totalItems else { return }
        from = to
        to = (from + 10) > totalItems ? (totalItems - from) : (from + 10)
        isAPaginationRequest = true
        isLoading = false

        recipeService
            .search(query: lastSearchKeyword, filter: lastSearchFilter?.rawValue, from: from, to: to)
            .sink { [weak self] (completion) in
                self?.isLoading = false
                self?.isAPaginationRequest = false
                
                if case .failure = completion {
                    print("failure in pagination")
                }
                
            } receiveValue: { [weak self] (response) in
                self?.setInteractorProperties(response: response)
            }
            .store(in: &subscriptions)
    }
    
    func saveSearchSuggestions() {
        suggestionsWorker.saveSuggestions(suggestions)
    }

    func fetchSearchSuggestions() {
        presenter?.interactor(self, didFetchSearchSuggestions: suggestions)
    }
    
    private func getSearchSuggestions() {
        suggestionsWorker.fetchSuggestions {
            [unowned self] (result: Result<[String], Error>) in
            switch result
            {
            case .success(let suggestions):
                self.suggestions = suggestions
                
            case .failure(let error):
                presenter?.interactor(self, didFailWith: error)
            }
        }
    }
    
    private func resetPaginationProperties() {
        from = 0
        to = 10
        hasMore = true
        totalItems = 0
    }
    
    private func setInteractorProperties(response: PagingResponse<Hit>) {
        guard let from = response.from, let to = response.to, let more = response.more, let totalItems = response.totalItems, let hits = response.data else {
            presenter?.interactor(self, didFailWith: SearchError.invalidSearchKeyowrd)
            return
        }
        
        guard !hits.isEmpty else {
            // don't show alert error ife in a pagination request and there is no more items
            if isAPaginationRequest { return }
            
            presenter?.interactor(self, didFailWith: SearchError.emptySearch)
            return
        }
        
        // we should calculate IndexPaths ForNewRows before update from and to values
        self.indexPathsToReload = Helper.instance.calculateIndexPathsForNewRows(from: from, to: to)
        self.from = from
        self.to = to
        self.hasMore = more
        self.totalItems = totalItems
        
        let newRecipes = getRecipesFrom(hits: hits)
        
        if isAPaginationRequest {
            let newSearchResults = self.searchResults.value + newRecipes
            self.searchResults.value = newSearchResults
            presenter?.interactor(self, didFetchNextPageResults: newSearchResults, indexPaths: indexPathsToReload)
        } else {
            searchResults.value = newRecipes
            presenter?.interactor(self, didFetchSearchOrFilterResults: searchResults.value)
        }
    }
    
    private func getRecipesFrom(hits: [Hit])-> [Recipe] {
        return hits.compactMap{ $0.recipe }
    }
}
