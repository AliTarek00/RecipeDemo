//
//  RecipeAPI.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Moya

enum RecipeAPI {
    case search(_ request: SearchRequest)
}

extension RecipeAPI: TargetType {
    var baseURL: URL {
        let base = "https://api.edamam.com"
        guard let url = URL(string: base) else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        switch self {
        case .search: return "/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            guard let path = Bundle.main.path(forResource: "searchSampleData", ofType: "json"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return Data()
            }
            return data
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var task: Task {
        switch self {
        case let .search(request):
            var parameters = ["app_id": AppAuthKeys.appId, "app_key": AppAuthKeys.appKey, "q": request.query, "from": request.from, "to": request.to] as [String : Any]
            if let healthFilter = request.filter {
                parameters["health"] = healthFilter
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
