//
//  UIViewExtension.swift
//  Almol Admin
//
//  Created by Ali Tarek on 10/10/20.
//  Copyright © 2020 Almol. All rights reserved.
//

import UIKit

extension UIView
{
    func setView(hidden: Bool)
    {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }

    func applyBlurEffect(_ style: UIBlurEffect.Style, parent: UIView)
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        // Applying a Blurring Effect to the Background Image
        blurEffectView.frame = parent.bounds
        self.addSubview(blurEffectView)
    }
}
