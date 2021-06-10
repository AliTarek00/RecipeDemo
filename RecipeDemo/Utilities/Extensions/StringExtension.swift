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
    
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    func isNotEmptyOrSpaces() -> Bool
    {
        return !self.isEmpty && (self.split(separator: " ")).count > 0
    }

    // MARK: Convert To DataType
    /// return Int if can else return 0
    func convertToInt() -> Int
    {
        if let number = Int(self)
        {
            return number
        }
        else
        {
            return 0
        }
    }
    
    /// return Double if can else return 0
    func convertToDouble() -> Double
    {
        if let number = Double(self)
        {
            return number
        }
        else
        {
            return 0.0
        }
    }
    
    // MARK: Time format Conversion
    
    func convertStringToDate()-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
        guard let date = dateFormatter.date(from: self) else {
            fatalError()
        }
        return date
    }
    
    /// convert 12 hour date to 24 hours date
    func timeConversion24() -> String {
        let dateAsString = self
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ssa"

        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"

        let time24 = df.string(from: date!)
        return time24
    }
    
    func convert24To12Format(strdateFormat: String, inputFormat: String)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = .current
        
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = strdateFormat
        let datestr = dateFormatter.string(from: date!)
        return datestr
    }
    
    // MARK: General
    
    func removeFractionFrom()-> String
    {
        guard let index = self.lastIndex(of: ".") else {
            print("can not trim 00 from text")
            return self
        }
        
        let trimmedText = String(self[..<index])
        return  trimmedText
    }

} // end of class
