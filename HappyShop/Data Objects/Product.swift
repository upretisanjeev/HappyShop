//
//  Product.swift
//  HappyShop
//
//  Created by Sanjeev on 21/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import Foundation

// MARK: - Class Product encapsulates basic information of a product
class Product:NSObject {

    // MARK: - product properties
    var id: Int!
    var name: String!
    var category: String!
    var price: NSDecimalNumber!
    var img_url: String!
    var under_sale: Bool!
    
    /// initializes the product properties using the given product dictionary.
    /// Product dictionary is created after data parsing from webservice.
    init(productDict:NSDictionary) {
        super.init()
        self.id = productDict["id"] as! Int
        self.name = productDict["name"] as! String
        self.category = productDict["category"] as! String
        self.price = NSDecimalNumber(string: "\(productDict["price"]!)")
        self.img_url = productDict["img_url"] as! String
        self.under_sale = productDict["under_sale"] as! Bool
    }
}
