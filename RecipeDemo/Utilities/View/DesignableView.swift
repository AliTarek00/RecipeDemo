//
//  DesignableView.swift
//  Almol
//
//  Created by Ali on 1/30/19.
//  Copyright © 2019 Almol. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView
{
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
    {
        didSet
        {
            self.layer.shadowOffset = self.shadowOffset
            self.drawShadow()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .black
    {
        didSet
        {
            self.layer.shadowColor = self.shadowColor.cgColor
            self.drawShadow()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0
    {
        didSet
        {
            self.layer.shadowRadius = self.shadowRadius
            self.drawShadow()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0
    {
        didSet
        {
            self.layer.shadowOpacity = self.shadowOpacity
            self.drawShadow()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0
    {
        didSet
        {
            self.layer.cornerRadius = cornerRadius
            //self.layer.masksToBounds = cornerRadius > 0 // false for shadow
        }
    }
    
    @IBInspectable var onlyTopCorner: Bool = false
        {
        didSet
        {
            if onlyTopCorner
            {
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            else
            {
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0
    {
        didSet
        {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black
    {
        didSet
        {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    private func drawShadow()
    {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
} // end of class


