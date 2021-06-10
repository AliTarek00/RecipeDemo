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
    
    // this closure to inject my custom activity indicator into moya providor as plugin
    private static let networkActivityClosure: NetworkActivityPlugin.NetworkActivityClosure =
    { (activity, _) in
        switch activity
        {
        case .began:
            ActivityIndicator.startAnimating()
        case .ended:
            ActivityIndicator.stopAnimating()
        }
    }
    private static let provider = MoyaProvider<RecipeAPI>(plugins: [VerbosePlugin(verbose: true), NetworkActivityPlugin(networkActivityClosure: networkActivityClosure)])
    
    // MARK: - Methods
    
    func search(query: String, filter: String?, from: Int, to: Int, completion: @escaping (Result<PagingResponse<Hit>, Error>) -> Void)
    {
        RecipeNetworkManager.provider.request(.search(query: query, filter: filter, from: from, to: to))
        { result in
            switch result
            {
            case .success(let value):
                let decoder = JSONDecoder()
                do
                {
                    let response = try decoder.decode(PagingResponse<Hit>.self, from: value.data)
                    completion(.success(response))
                }
                catch let error
                {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
