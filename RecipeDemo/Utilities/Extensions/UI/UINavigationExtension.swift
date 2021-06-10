//
//  UINavigationExtension.swift
//  Almol
//
//  Created by Ali Tarek on 1/6/20.
//  Copyright © 2020 Ali Tarek. All rights reserved.
//

import UIKit

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
