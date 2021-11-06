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

    func search(request: SearchRequest)-> AnyPublisher<PagingResponse<Hit>, Error>
}
