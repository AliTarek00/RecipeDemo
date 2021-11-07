//
//  UIViewController.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 07/11/2021.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, ViewController: UIViewController, completion: (() -> Void)? = nil) {
       DispatchQueue.main.async
           {
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                   completion?()
               })
               let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
               
               alert.addAction(okAction)
               alert.addAction(cancelAction)
               ViewController.present(alert, animated: true)
       }
   }
   
   func showConfirmAlert(controller: UIViewController, title: String, completion: @escaping (_ confirmed: Bool) -> Void) {
       let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
       
       let okayAction = UIAlertAction(title: "confirm", style: .default) {
           UIAlertAction in
           completion(true)
       }
       
       let cancelAction = UIAlertAction(title: "cancel", style: .cancel) {
           UIAlertAction in
           completion(false)
       }
       
       alert.addAction(okayAction)
       alert.addAction(cancelAction)
       controller.present(alert, animated: true)
   }
    
    func startLoading() {
        ActivityIndicator.startAnimating(onView: self.view)
    }
    
    func stopLoading() {
        ActivityIndicator.stopAnimating(onView: self.view)
    }
}
