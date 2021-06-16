//
//  RecipeNetworkManger.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Moya

class RecipeNetworkManager: RecipeNetworkable
{
    // MARK: Properties
    
    private let moyaAPIHelper: MoyaAPIHelper<RecipeAPI>
    
    // MARK: Init
   
    init(type: ServiceType = .production, withLogger: Bool = true)
    {
        moyaAPIHelper = MoyaAPIHelper(type: type, withLogger: withLogger)
    }
    
    // MARK: - Methods
    
    func search(query: String, filter: String?, from: Int, to: Int, completion: @escaping (Result<PagingResponse<Hit>, Error>) -> Void)
    {
        let request: RecipeAPI = .search(query: query, filter: filter, from: from, to: to)
        moyaAPIHelper.request(targetCase: request, completion: completion)
    }
}
