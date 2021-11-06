//
//  RecipeEnums.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/14/21.
//

import Foundation

enum SearchError: Error {
    case emptySearch
    case invalidSearchKeyowrd
    case emptySearchSuggestion
}

extension SearchError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptySearch:
            return NSLocalizedString("Empty Search Results, Try Again!", comment: "")
            
        case .invalidSearchKeyowrd:
            return NSLocalizedString("Plese Enter Valid Search Keyword", comment: "")
            
        case .emptySearchSuggestion:
            return NSLocalizedString("empty search suggestion", comment: "")
        }
    }
}

enum HealthFilter: String, Codable {
    case all
    case lowSugar = "low-sugar"
    case keto = "keto-friendly"
    case vegan = "vegan"
}

enum RecipeSegues: String {
    case recipeDetails = "showRecipeDetails"
}
