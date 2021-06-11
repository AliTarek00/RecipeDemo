//
//  Enums.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation


enum AppAuthKeys
{
    static let appId = "0dca1f64"
    static let appKey = "17abc68ea5ab0c94c958a4dd60e27c71"
}

enum SearchError: Error
{
    case emptySearch
    case invalidSearchKeyowrd
    case emptySearchSuggestion
}

extension SearchError: LocalizedError
{
    var errorDescription: String?
    {
        switch self
        {
        case .emptySearch:
            return NSLocalizedString("Empty Search Results, Try Again!", comment: "")
            
        case .invalidSearchKeyowrd:
            return NSLocalizedString("Plese Enter Valid Search Keyword", comment: "")
            
        case .emptySearchSuggestion:
            return NSLocalizedString("empty search suggestion", comment: "")
        }
    }
}

enum HealthFilter: String
{
    case all
    case lowSugar = "low-sugar"
    case keto = "keto-friendly"
    case vegan = "vegan"
}

