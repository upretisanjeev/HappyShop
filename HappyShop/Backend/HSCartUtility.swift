//
//  HSCartUtility.swift
//  HappyShop
//
//  Created by Sanjeev Upreti on 24/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import Foundation
import UIKit

// MARK: - Utility class contain methods to get info and manipulate the user's cart

class HSCartUtility {
    
    // MARK: - Singleton declaration
    static let sharedCartUtility = HSCartUtility()
    
    // MARK: - Properties
    /// formatting currency
    lazy var currencyFormatter: NSNumberFormatter = {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        // currently hardcoding for India
        currencyFormatter.locale = NSLocale.init(localeIdentifier: "en_IN")
        currencyFormatter.currencySymbol = "INR"
        currencyFormatter.currencyGroupingSeparator = ","
        currencyFormatter.currencyDecimalSeparator = "."
        return currencyFormatter;
    }()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    /// Save the given productId in user's cart.
    ///
    /// All productIds in user's cart are saved in an array. Array is saved in UserDefaults.
    func saveItemInCart(productId: Int?) -> Bool {
        guard let productId = productId else {
            print("productId parameter found nil")
            return false
        }
        var itemsIdInCart = HSCartUtility.sharedCartUtility.itemsIdInCart()
        if (itemsIdInCart == nil) {
            itemsIdInCart = [Int]()
        }
        itemsIdInCart?.append(productId)
        NSUserDefaults.standardUserDefaults().setObject(itemsIdInCart, forKey: "HSCartItemsIdArray")
        return true
    }
    
    /// Remove the given productId from user's cart.
    func removeItemFromCart(productId: Int?) -> Bool {
        guard let productId = productId else {
            print("productId parameter found nil")
            return false
        }
        var itemsIdInCart = HSCartUtility.sharedCartUtility.itemsIdInCart()
        if (itemsIdInCart == nil) {
            print("Cart is empty")
            return false
        }
        itemsIdInCart?.removeObject(productId)
        NSUserDefaults.standardUserDefaults().setObject(itemsIdInCart, forKey: "HSCartItemsIdArray")
        return true
    }
    
    /// Returns an array containing ids of products in user's cart.
    func itemsIdInCart() -> [Int]? {
        return NSUserDefaults.standardUserDefaults().arrayForKey("HSCartItemsIdArray") as? [Int]
    }
    
    /// Check whether the given productId already exists in user's cart or not.
    ///
    /// Returns true if productId already exists in user's cart.
    func checkIfItemExistsInCart(productId: Int?) -> Bool {
        guard let productId = productId else {
            print("productId parameter found nil")
            return false
        }

        let itemsIdInCart = HSCartUtility.sharedCartUtility.itemsIdInCart()
        if (itemsIdInCart == nil) {
            return false
        }
        
        return (itemsIdInCart?.contains(productId))!
    }
    
    /// Set the badge value for tab-bar-item associated with Cart
    func updateCartStatus() {
        var itemsIdInCart = HSCartUtility.sharedCartUtility.itemsIdInCart()
        if (itemsIdInCart == nil) {
            itemsIdInCart = [Int]()
        }

        let app = UIApplication.sharedApplication()
        let tabBarController = app.keyWindow?.rootViewController as! UITabBarController
        let tabBarItemOfCart = tabBarController.tabBar.items?.last
        if itemsIdInCart?.count == 0 {
            tabBarItemOfCart?.badgeValue = nil
        }
        else {
            tabBarItemOfCart?.badgeValue = String(itemsIdInCart!.count)
        }
    }
    
}