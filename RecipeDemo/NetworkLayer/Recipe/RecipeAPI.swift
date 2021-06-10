//
//  RecipeAPI.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Moya

enum  RecipeAPI
{
    static private let appId = "0dca1f64"
    static private let appKey = "17abc68ea5ab0c94c958a4dd60e27c71"
    
    case search(query: String, filter: String?, from: Int, to: Int)
}

extension RecipeAPI: TargetType
{
    var baseURL: URL
    {
        let base = "https://api.edamam.com"
        guard let url = URL(string: base) else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String
    {
        switch self
        {
        case .search: return "/search"
        }
    }
    
    var method: Moya.Method
    {
        switch self
        {
        case .search:
            return .get
        }
    }
    
    var sampleData: Data
    {
        return Data()
    }
    
    var headers: [String : String]?
    {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType
    {
      return .successCodes
    }
    
    var task: Task
    {
        switch self
        {
        case let .search(query, filter, from, to):
            var parameters = ["app_id": RecipeAPI.appId, "app_key": RecipeAPI.appKey, "q": query]
            if let healthFilter = filter
            {
                parameters["health"] = healthFilter
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
