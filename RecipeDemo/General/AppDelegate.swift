//
//  AppDelegate.swift
//  RecipeDemo
//
//  Created by Ali Tarek on 6/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var searchViewController: SearchViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        if let rootNavigationController = application.windows.first?.rootViewController as? UINavigationController,
            let searchView = rootNavigationController.viewControllers.first as? SearchViewController
        {
            searchViewController = searchView
            SearchBuilder.buildModule(arroundView: searchView)
        }
        
        return true
    }
    
    @available(iOS 11.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return false
    }
}

