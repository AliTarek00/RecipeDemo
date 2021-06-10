//
//  DesignableImageView.swift
//  Almol
//
//  Created by Ali Tarek on 1/30/19.
//  Copyright © 2019 Almol. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
}

