//
//  UIViewControllerExtension.swift
//  Almol
//
//  Created by Ali Tarek on 3/28/20.
//  Copyright © Ali Tarek. All rights reserved.
//

import NVActivityIndicatorView

extension UIViewController
{
    func getActivityIndicator() -> NVActivityIndicatorView
    {
        let x = ( self.view.frame.size.width / 2.0 ) - ( 50.0 / 2.0 )
        let y = ( self.view.frame.size.height / 2.0 ) - ( 50.0 / 2.0 )
        let theFrame = CGRect(x: x, y: y, width: CGFloat(50), height: CGFloat(50))
        
        let indicator = NVActivityIndicatorView(frame: theFrame, type: .ballRotateChase, color: .appGreen)
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        return indicator
    }
    
    func addImageToNavBar(_ image: UIImage)
    {
        let imageView = UIImageView(image: image)
        self.navigationItem.titleView = imageView
    }
}
