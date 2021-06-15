//
//  UIColorExtension.swift
//  Almol
//
//  Created by Ali Tarek on 1/30/20.
//  Copyright © 2020 Ali Tarek. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    
    static var appGreen: UIColor
    {
        return UIColor(hexa: 0x2DD66A)
    }
    
    static var appDarkGray: UIColor
    {
        return UIColor(hexa: 0x575757)
    }
        
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexa: Int)
    {
        self.init(
            red: (hexa >> 16) & 0xFF,
            green: (hexa >> 8) & 0xFF,
            blue: hexa & 0xFF
        )
    }
    
    // How to use :
    // theButton.BackgroundColor = UIColor.color(colorCode: 0xFFFFFF)
}
