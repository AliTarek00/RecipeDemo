//
//  SearchInteractor.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol SearchInteractorProtocol
{
    func fetchSearchResults(query: String, filter: String?, from: Int, to: Int)
}

class SearchInteractor: SearchInteractorProtocol
{
    // MARK: - Properties

    // pagination properties
    
    private var from: Int?
    private var to: Int?
    private var totalItems: Int?
    private var more: Bool?
    
    private var hits:[Hit]?
    private let networkManager: RecipeNetworkable
    
    var presenter: SearchPresenterProtocol?

    required init(networkManager: RecipeNetworkable)
    {
        self.networkManager = networkManager
    }
    
    
    // MARK: - Methods

    func fetchSearchResults(query: String, filter: String?, from: Int = 0, to: Int = 10)
    {
        networkManager.search(query: query, filter: filter, from: from, to: to)
            { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
                
                switch result
                {
                case .success(let response):
                    setInteractorProperties(response: response)
                    extractRecipes(fromHits: response.data)
                    
                case .failure(let error):
                    presenter?.interactor(self, didFailWith: error)
                }
        }
    }
    
    private func setInteractorProperties(response: PagingResponse<Hit>)
    {
        from = response.from
        to = response.to
        more = response.more
        totalItems = response.totalItems
        
        hits = response.data
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
