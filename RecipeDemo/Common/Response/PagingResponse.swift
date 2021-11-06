//
//  PagingResponse.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import Foundation

struct PagingResponse<Data: Codable>: Codable {
    let status : String?
    let message: String?
    let data : [Data]?
    
    let from: Int?
    let to: Int?
    let more: Bool?
    let totalItems: Int?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "hits"
        
        case from = "from"
        case to = "to"
        case more = "more"
        case totalItems = "count"
    }
}
