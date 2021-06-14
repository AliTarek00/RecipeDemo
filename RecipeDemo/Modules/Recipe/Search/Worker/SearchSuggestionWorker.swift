//
//  SearchSuggestionWorker.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/11/21.
//

import Foundation

protocol SearchSuggestionWorkerProtocol
{
    func fetchSuggestions(completion: (Result<[String], Error>) -> Void)
    func saveSuggestions(_ suggestions: [String])
    func addNewSuggestion(_ searchKeywrd: String)-> [String]
}

class SearchSuggestionWorker: SearchSuggestionWorkerProtocol
{
    lazy var sugesstionsArray = SearchSuggestionArray<String>(size: 10)
    
    func fetchSuggestions(completion: (Result<[String], Error>) -> Void)
    {
        guard let searchSuggestions = UserDefaults.standard.array(forKey: "SearchSuggestions") as? [String] else
        {
            completion(.failure(SearchError.emptySearchSuggestion))
            return
        }
        sugesstionsArray.addItems(items: searchSuggestions)
        completion(.success(searchSuggestions))
    }
    
    func saveSuggestions(_ suggestions: [String])
    {
        UserDefaults.standard.setValue(suggestions, forKey: "SearchSuggestions")
    }
    
    func addNewSuggestion(_ searchKeywrd: String)-> [String]
    {
        return sugesstionsArray.addAndReturnReversedArray(searchKeywrd)
    }

}
