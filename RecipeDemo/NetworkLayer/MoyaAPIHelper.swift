//
//  MoyaAPIHelper.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/17/21.
//

import Moya

enum ServiceType
{
    case production
    case test
}

class MoyaAPIHelper<T: TargetType>
{
    // MARK:- Properties
    
    private var provider: MoyaProvider<T>
    
    // MARK:- Init
    
    init(type: ServiceType, withLogger: Bool)
    {
        let networkActivityClosure: NetworkActivityPlugin.NetworkActivityClosure =
            { (activity, _) in
                
                switch activity
                {
                case .began:
                    ActivityIndicator.startAnimating()
                    
                case .ended:
                    ActivityIndicator.stopAnimating()
                }
            }
        
        var plugins: [PluginType] = []
        
        let networkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: networkActivityClosure)
        plugins.append(networkActivityPlugin)
        
        let networkLogger = CustomLoggerPlugin(verbose: withLogger)
        plugins.append(networkLogger)
        
        let serviceType = type == .production ? MoyaProvider<T>.neverStub : MoyaProvider<T>.immediatelyStub
        
        self.provider = MoyaProvider<T>(stubClosure: serviceType, plugins: plugins)
    }
    
    // MARK:- Methods
    
    func request<C: Codable>(targetCase: T,
                             completion: @escaping (Result<PagingResponse<C>,
                                                           Error>) -> Void)
    {
        provider.request(targetCase) { result in
            switch result
            {
            case .success(let value):
                let decoder = JSONDecoder()
                do
                {
                    let response = try decoder.decode(PagingResponse<C>.self, from: value.data)
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
