//
//  UIImageViewExtension.swift
//  Almol Admin
//
//  Created by Ali Tarek on 11/27/20.
//  Copyright © 2020 Almol. All rights reserved.
//

import SDWebImage

extension UIImageView
{
    func setImage(from url: String?, placeholderImage: UIImage? = #imageLiteral(resourceName: "add image"))
    {
        if let url = url
        {
            let theURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
            guard let url = URL(string: theURL) else { return }
            self.image = nil
            self.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
    }
}
