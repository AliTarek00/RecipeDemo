//
//  SearchRequest.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 06/11/2021.
//

import Foundation

struct SearchRequest: Codable {
    let query: String
    let filter: HealthFilter?
    let from: Int
    let to: Int
}
