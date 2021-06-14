//
//  FixedArray.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/11/21.
//

import Foundation

/// This is a helper calss used in Search auto suggesstion feature

public struct SearchSuggestionArray<T>
{
    private (set) var array: [T?]
    private (set) var currentItems = 0
    private var maximumSize = 0
    
    public init(size: Int)
    {
        self.array = [T?](repeating: nil, count: size)
        self.maximumSize = size
    }
    
    public mutating func addItems(items: [T])
    {
        array = items
        currentItems = items.count
    }
    
    /// This function append new element to array and if array is full remove first element and append and finally return a reversed  copy from elements
    public mutating func addAndReturnReversedArray(_ element: T) -> [T]
    {
        if currentItems < maximumSize
        {
            array.append(element)
            currentItems += 1
        }
        else
        {
            array.removeFirst()
            array.append(element)
        }
        
        return Array(array.compactMap{$0}.reversed())
    }
    
}
