//
//  RecipeNetworkProtocol.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation
import Combine

protocol RecipeNetworkable: AnyObject
{
    // MARK: Methods

    func search(query: String, filter: String?, from: Int, to: Int)-> AnyPublisher<PagingResponse<Hit>, Error>
}
