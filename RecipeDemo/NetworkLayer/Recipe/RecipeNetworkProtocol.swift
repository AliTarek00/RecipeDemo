//
//  RecipeNetworkProtocol.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

protocol RecipeNetworkable: class
{
    // MARK: Methods

    func search(query: String, filter: String?, from: Int, to: Int, completion: @escaping (Result<PagingResponse<Hit>, Error>) -> Void)    
}
