//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    var searchKeyword: CurrentValueSubject<String, Never> { set get }
    var searchFilter: CurrentValueSubject<HealthFilter?, Never> { set get }
    var searchResults: CurrentValueSubject<[Recipe], Never> { get }
    var nextPageResults: CurrentValueSubject<[Recipe], Never> { get }
    var searchSuggestions: CurrentValueSubject<[String], Never> { get }
    var errorMessage: CurrentValueSubject<String?, Never> { get }
    
    func fetchNextPageForSearchResults()
    func getCellViewModel(atIndex index: IndexPath)->SearchResultCellViewModel
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
    private (set) lazy var searchResults = CurrentValueSubject<[Recipe],Never>([Recipe]())
    private (set) lazy var nextPageResults = CurrentValueSubject<[Recipe],Never>([Recipe]())
    private (set) lazy var searchSuggestions = CurrentValueSubject<[String],Never>([String]())
    private (set) lazy var errorMessage = CurrentValueSubject<String?,Never>(nil)
    
    lazy var searchKeyword = CurrentValueSubject<String,Never>("")
    lazy var searchFilter = CurrentValueSubject<HealthFilter?,Never>(nil)
    //var presenter: SearchPresenterProtocol?
    
    required init(recipeService: RecipeNetworkable = RecipeNetworkManager(), suggestionsWorker: SearchSuggestionWorkerProtocol = SearchSuggestionWorker()) {
        self.recipeService = recipeService
        self.suggestionsWorker = suggestionsWorker
        self.getSearchSuggestions()
        
        setupPublishers()
    }
    
    deinit {
        suggestionsWorker.saveSuggestions(searchSuggestions.value)
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
            .filter{$0.isNotEmptyOrSpaces()}
            .map { [unowned self] (keyword)-> AnyPublisher<PagingResponse<Hit>, Error> in
                if !searchSuggestions.value.contains(keyword) {
                    searchSuggestions.value = suggestionsWorker.addNewSuggestion(keyword)
                }
                return self.createSearchPublisher()
            }
            .setFailureType(to: Error.self) // this to make switchToLatest works in ios 13
            .switchToLatest()
            .sink{ [unowned self] (completion) in
                handleSeacrhCompletion()
                if case .failure(let error) = completion {
                    errorMessage.value = error.localizedDescription
                }
            } receiveValue: { [unowned self] (response) in
                handleSeacrhCompletion()
                setViewModelProperties(response: response)
            }.store(in: &subscriptions)
        
    }
    
    private func setupFilterPublisher() {
        searchFilter
            .removeDuplicates()
            .compactMap{$0}
            .map{ [unowned self] (filter)-> AnyPublisher<PagingResponse<Hit>, Error> in
                return self.createSearchPublisher()
            }
            .setFailureType(to: Error.self) // this to make switchToLatest works in ios 13
            .switchToLatest()
            .sink{ [unowned self] (completion) in
                handleSeacrhCompletion()
                if case .failure(let error) = completion {
                    errorMessage.value = error.localizedDescription
                }
            } receiveValue: { [unowned self] (response) in
                handleSeacrhCompletion()
                setViewModelProperties(response: response)
            }.store(in: &subscriptions)
    }
    
    private func createSearchPublisher()-> AnyPublisher<PagingResponse<Hit>, Error> {
        resetPaginationProperties()
        isLoading = true
        
        let request = SearchRequest(query: searchKeyword.value, filter: searchFilter.value, from: from, to: to)
        return recipeService
            .search(request: request)
        
    }
        
    func fetchNextPageForSearchResults() {
        print("fetchNextPageForSearchResults")
        guard hasMore, !isLoading, from + to < totalItems else { return }
        from = to
        to = (from + 10) > totalItems ? (totalItems - from) : (from + 10)
        isAPaginationRequest = true
        isLoading  = true
        
        let request = SearchRequest(query: searchKeyword.value, filter: searchFilter.value, from: from, to: to)
        recipeService
            .search(request: request)
            .sink { [weak self] (completion) in
                self?.handleSeacrhCompletion()
                if case .failure(let error) = completion {
                    self?.errorMessage.value = error.localizedDescription
                }
            } receiveValue: { [unowned self] (response) in
              isLoading = false
                setViewModelProperties(response: response)
            }
            .store(in: &subscriptions)
    }
    
    private func handleSeacrhCompletion() {
       isLoading = false
       isAPaginationRequest = false
    }
    
    private func getSearchSuggestions() {
        suggestionsWorker.fetchSuggestions {
            [unowned self] (result: Result<[String], Error>) in
            switch result {
            case .success(let suggestions):
                self.searchSuggestions.value = suggestions
                
            case .failure(let error):
                print(error.localizedDescription)
                // self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func resetPaginationProperties() {
        from = 0
        to = 10
        hasMore = true
        totalItems = 0
    }
    
    private func setViewModelProperties(response: PagingResponse<Hit>) {
        guard let from = response.from, let to = response.to, let more = response.more, let totalItems = response.totalItems, let hits = response.data else {
            self.errorMessage.value = SearchError.invalidSearchKeyowrd.localizedDescription
            return
        }
        
        guard !hits.isEmpty else {
            // don't show alert error if in a pagination request and there is no more items
            if isAPaginationRequest { return }
            self.errorMessage.value = SearchError.emptySearch.localizedDescription
            return
        }
        
        self.from = from
        self.to = to
        self.hasMore = more
        self.totalItems = totalItems
        
        let newRecipes = getRecipesFrom(hits: hits)
        
        if isAPaginationRequest {
            let newSearchResults = self.searchResults.value + newRecipes
            nextPageResults.value = newSearchResults
        } else {
            searchResults.value = newRecipes
        }
    }
    
    func getCellViewModel(atIndex index: IndexPath) -> SearchResultCellViewModel {
        let recipe = searchResults.value[index.row]
        return getViewModelFrom(recipe: recipe)
    }
    
}

// MARK: - Data Converion
extension SearchViewModel {
    
    private func getRecipesFrom(hits: [Hit])-> [Recipe] {
        return hits.compactMap{ $0.recipe }
    }
    
    private func getViewModelFrom(recipe: Recipe)-> SearchResultCellViewModel {
        let healthLabels = recipe.healthLabels.joined(separator: ", ")
        let viewModel = SearchResultCellViewModel(imageLink: recipe.image, title: recipe.label, source: recipe.source, healthLabels: healthLabels)
        
        return viewModel
    }
    
}
