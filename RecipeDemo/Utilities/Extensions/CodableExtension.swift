//
//  CodableExtension.swift
//  Almol Admin
//
//  Created by Ali Tarek on 11/28/20.
//  Copyright © 2020 Almol. All rights reserved.
//

import Foundation

// MARK: Encodable

extension Encodable
{
    func toJSONData() -> Data
    {
        let data = try? JSONEncoder().encode(self)
        return data ?? Data()
    }
    
    func toJSONString() -> String
    {
        let string = String(data: self.toJSONData(), encoding: String.Encoding.utf8) ?? ""
        return string
    }
    
    func toJSONObject() -> [String: Any]
    {
        let jsonObject = try? JSONSerialization.jsonObject(with: self.toJSONData(), options: []) as? [String: Any]
        return jsonObject ?? [:]
    }
}

// MARK: Decodable
