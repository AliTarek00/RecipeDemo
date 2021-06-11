//
//  FixedArray.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/11/21.
//

import Foundation

// This is a helper calss used in Search auto suggesstion feature
public struct SearchSuggestionArray<T>
{
   var array: [T?]
   var currentItems = 0

  public init(size: Int)
  {
    self.array = [T?](repeating: nil, count: size)
  }

  /// This function append new element to array and if array is full remove first element and append and finally return a reversed  copy from elements
  public mutating func addAndReturnReversedArray(_ element: T) -> [T]
  {
    if currentItems < array.count
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
