//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    var searchKeyword: CurrentValueSubject<String, Never> { get }
    var searchResults: CurrentValueSubject<[SearchResultCellViewModel], Never> { get }
    var nextPageResults: CurrentValueSubject<[SearchResultCellViewModel], Never> { get }
    var searchSuggestions: CurrentValueSubject<[String], Never> { get }
    var searchFilter: CurrentValueSubject<HealthFilter, Never> { get }
    var errorMessage: CurrentValueSubject<String?, Never> { get }
    
    func fetchNextPageForSearchResults()
    func fetchSearchSuggestions()
    func saveSearchSuggestions()
}

class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Properties
    private let recipeService: RecipeNetworkable
    private let suggestionsWorker: SearchSuggestionWorkerProtocol
    private lazy var from: Int = 0
    private lazy var to: Int = 10
    private lazy var totalItems: Int = 0
    private lazy var hasMore: Bool = true
    private lazy var isAPaginationRequest = false
    
    private lazy var subscriptions = Set<AnyCancellable>()
    private (set) lazy var isLoading: Bool = false
    private (set) lazy var searchResults = CurrentValueSubject<[SearchResultCellViewModel],Never>([SearchResultCellViewModel]())
    private (set) lazy var nextPageResults = CurrentValueSubject<[SearchResultCellViewModel],Never>([SearchResultCellViewModel]())
    private (set) lazy var searchSuggestions = CurrentValueSubject<[String],Never>([String]())
    private (set) lazy var errorMessage = CurrentValueSubject<String?,Never>(nil)
    
    lazy var searchKeyword = CurrentValueSubject<String,Never>("")
    lazy var searchFilter = CurrentValueSubject<HealthFilter,Never>(.all)
    //var presenter: SearchPresenterProtocol?
    
    required init(recipeService: RecipeNetworkable = RecipeNetworkManager(), suggestionsWorker: SearchSuggestionWorkerProtocol = SearchSuggestionWorker()) {
        self.recipeService = recipeService
        self.suggestionsWorker = suggestionsWorker
        self.getSearchSuggestions()
        
        setupPublishers()
    }
    
    // MARK: - Methods
    
    private func setupPublishers() {
        setupSearchPublisher()
        setupFilterPublisher()
    }
    
    private func setupSearchPublisher() {
        searchKeyword
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { $0.isNotEmptyOrSpaces()}
            .sink{ (_) in
            } receiveValue: { [weak self] (keyword) in
                self?.search(WithKeyowrd: keyword)
            }.store(in: &subscriptions)
        
    }
    
    private func setupFilterPublisher() {
        searchFilter
            .removeDuplicates()
            .sink{ (_) in
            } receiveValue: { [weak self] (filter) in
                self?.filterResults(WithFilter: filter)
            }.store(in: &subscriptions)
    }
    
    private func search(WithKeyowrd query: String) {
        
        if !searchSuggestions.value.contains(query) {
            searchSuggestions.value = suggestionsWorker.addNewSuggestion(query)
            presenter?.interactor(self, didFetchSearchSuggestions: searchSuggestions.value)
        }
        
        resetPaginationProperties()
        isLoading = true
        
        let request = SearchRequest(query: query, filter: searchFilter.value, from: from, to: to)
        recipeService
            .search(request: request)
            .sink { [weak self] (completion) in
                self?.isLoading = false
                self?.isAPaginationRequest = false
                self?.searchKeyword.value = query
                
                if case .failure(let error) = completion {
                    self?.errorMessage.value = error.localizedDescription
                }
                
            } receiveValue: { [weak self] (response) in
                self?.setInteractorProperties(response: response)
            }
            .store(in: &subscriptions)
    }
    
    private func filterResults(WithFilter filter: HealthFilter) {
        let selectedFilter = filter == .all ? nil : filter
        resetPaginationProperties()
        isLoading = false
        
        let request = SearchRequest(query: searchKeyword.value, filter: selectedFilter, from: from, to: to)
        recipeService
            .search(request: request)
            .sink { [weak self] (completion) in
                self?.isLoading = false
                self?.isAPaginationRequest = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage.value = error.localizedDescription
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
        
        let request = SearchRequest(query: searchKeyword.value, filter: searchFilter.value, from: from, to: to)
        recipeService
            .search(request: request)
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
        suggestionsWorker.saveSuggestions(searchSuggestions.value)
    }
    
    private func getSearchSuggestions() {
        suggestionsWorker.fetchSuggestions {
            [unowned self] (result: Result<[String], Error>) in
            switch result
            {
            case .success(let suggestions):
                self.searchSuggestions.value = suggestions
                
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
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
            self.errorMessage.value = SearchError.invalidSearchKeyowrd.localizedDescription
            return
        }
        
        guard !hits.isEmpty else {
            // don't show alert error ife in a pagination request and there is no more items
            if isAPaginationRequest { return }
            self.errorMessage.value = SearchError.emptySearch.localizedDescription
            return
        }
        
        self.from = from
        self.to = to
        self.hasMore = more
        self.totalItems = totalItems
        
        let newRecipes = getRecipesFrom(hits: hits)
        let searchResultsVMs = convertRecipesToSearchResultsViewModels(recipes: newRecipes)
        
        if isAPaginationRequest {
            let newSearchResults = self.searchResults.value + searchResultsVMs
            nextPageResults.value = newSearchResults
        } else {
            searchResults.value = searchResultsVMs
        }
    }
    
}

// MARK: - Data Converion
extension SearchViewModel {
    
    private func getRecipesFrom(hits: [Hit])-> [Recipe] {
        return hits.compactMap{ $0.recipe }
    }
    
    private func convertRecipesToSearchResultsViewModels(recipes: [Recipe])-> [SearchResultCellViewModel] {
        let resultsViewModels = recipes.compactMap { (recipe) -> SearchResultCellViewModel? in
            let healthLabels = recipe.healthLabels.joined(separator: ", ")
            let viewModel = SearchResultCellViewModel(imageLink: recipe.image, title: recipe.label, source: recipe.source, healthLabels: healthLabels)
            
            return viewModel
        }
        return resultsViewModels
    }
    
}
