//
//  MoyaAPIHelper.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/17/21.
//

import Moya
import Combine
import Foundation

enum ServiceType {
    case production
    case test
}

class MoyaAPIHelper<T: TargetType> {
    
    // MARK: Properties
    
    private var provider: MoyaProvider<T>
    
    // MARK: Init
    
    init(type: ServiceType, withLogger: Bool) {
        
        let plugins: [PluginType] = [CustomLoggerPlugin(verbose: withLogger)]
    
        let serviceType = type == .production ? MoyaProvider<T>.neverStub : MoyaProvider<T>.immediatelyStub
        
        self.provider = MoyaProvider<T>(stubClosure: serviceType, plugins: plugins)
    }
    
    //MARK: Methods
    
    func request<C: Codable>(targetCase: T)->AnyPublisher<C, Error> {
        provider
            .requestPublisher(targetCase)
            .map { $0.data }
            .decode(type: C.self, decoder: JSONDecoder())
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
