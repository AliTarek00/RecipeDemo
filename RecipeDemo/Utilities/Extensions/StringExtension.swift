//
//  StringExtensions.swift
//  Almol
//
//  Created by Ali Tarek on 1/30/20.
//  Copyright © 2020 Ali Tarek. All rights reserved.
//
//

import Foundation

extension String
{
    // MARK: Text Validation
    
    func isNotEmptyOrSpaces() -> Bool
    {
        return !self.isEmpty && (self.split(separator: " ")).count > 0
    }
    
}
