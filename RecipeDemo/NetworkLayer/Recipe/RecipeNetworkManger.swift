//
//  RecipeNetworkManger.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Moya
import Combine

class RecipeNetworkManager: RecipeService {
    // MARK: Properties
    
    private let moyaAPIHelper: MoyaAPIHelper<RecipeAPI>
    
    // MARK: Init
   
    init(type: ServiceType = .production, withLogger: Bool = true) {
        moyaAPIHelper = MoyaAPIHelper(type: type, withLogger: withLogger)
    }
    
    // MARK: - Methods
    
    func search(request: SearchRequest)-> AnyPublisher<PagingResponse<Hit>, Error> {
        let endpoint: RecipeAPI = .search(request)
        return moyaAPIHelper.request(targetCase: endpoint)
    }
}
