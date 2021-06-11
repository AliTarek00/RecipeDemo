//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol SearchInteractorProtocol
{
    func fetchSearchResults(query: String, filter: HealthFilter)
    func getNextPageForSearchResults()
    func getSearchSuggestions()
}

class SearchInteractor: SearchInteractorProtocol
{
    // MARK: - Properties
    
    lazy var lastSearchKeyword: String = ""
    lazy var lastSearchFilter: HealthFilter = .all
    lazy var isLoading = false

    var presenter: SearchPresenterProtocol?
    
    // pagination properties
    private lazy var from: Int = 0
    private lazy var to: Int = 10
    private lazy var totalItems: Int = 0
    private lazy var hasMore: Bool = true
    private lazy var hits:[Hit] = [Hit]()
    
    private let networkManager: RecipeNetworkable
    
    required init(networkManager: RecipeNetworkable)
    {
        self.networkManager = networkManager
    }
    
    // MARK: - Methods
    

    func fetchSearchResults(query: String, filter: HealthFilter)
    {
        guard query.isNotEmptyOrSpaces(), query != lastSearchKeyword else
        {
            presenter?.interactor(self, didFailWith: SearchError.invalidSearchKeyowrd)
            return
        }
        guard filter != lastSearchFilter else
        {
            return
        }
        
        let filterValue = filter == .all ? nil : filter.rawValue
        isLoading = true
        
        networkManager.search(query: query, filter: filterValue, from: from, to: to)
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
            lastSearchKeyword = query
            lastSearchFilter = filter
        }
    }
    
    func getNextPageForSearchResults()
    {
        guard hasMore, !isLoading, from + to < totalItems else {
            return
        }
        self.from = self.to
        self.to = from + 10
        fetchSearchResults(query: lastSearchKeyword, filter: lastSearchFilter)
    }
    
    func getSearchSuggestions()
    {
        //
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
        self.hits = hits
    }
    
    private func extractRecipes(fromHits hits: [Hit]?)
    {
        guard let hits = hits else
        {
            presenter?.interactor(self, didFailWith: SearchError.emptySearch)
            return
        }
        
        let recipes = hits.compactMap{ $0.recipe }
        presenter?.interactor(self, didFetch: recipes)
    }
}
