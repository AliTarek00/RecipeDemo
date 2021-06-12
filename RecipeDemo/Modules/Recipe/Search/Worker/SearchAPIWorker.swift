//
//  SearchAPIWorker.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/12/21.
//

import Foundation

protocol SearchAPIWorkerProtocol
{
    var isLoading: Bool { get }
    func fetchSearchResults(query: String, filter: String?, from: Int, to: Int,  completion: @escaping (Result<PagingResponse<Hit>, Error>) -> Void)
}

class SearchAPIWorker: SearchAPIWorkerProtocol
{
    private (set) lazy var isLoading: Bool = false
    private let networkManager: RecipeNetworkable
    
    required init(networkManager: RecipeNetworkable)
    {
        self.networkManager = networkManager
    }

    func fetchSearchResults(query: String, filter: String?, from: Int, to: Int, completion: @escaping (Result<PagingResponse<Hit>, Error>) -> Void)
    {
        isLoading = true
        networkManager.search(query: query, filter: filter, from: from, to: to)
        { [unowned self] (result: Result<PagingResponse<Hit>, Error>) in
            
            switch result
            {
            case .success(let response):
                completion(.success(response))

            case .failure(let error):
                completion(.failure(error))
            }
            self.isLoading = false
        }
    }
}
