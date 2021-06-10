//
//  Enums.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

enum SearchError: Error
{
    case emptySearch
}

extension SearchError: LocalizedError
{
    var errorDescription: String?
    {
        switch self
        {
        case .emptySearch:
            return NSLocalizedString("Empty Search Results, Try Again!", comment: "")
        }
    }
}
