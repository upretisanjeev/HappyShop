//
//  ProductDetail.swift
//  HappyShop
//
//  Created by Sanjeev Upreti on 23/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import UIKit

// MARK: - Class ProductDetails encapsulates detailed information of a product
class ProductDetail: Product {

    // MARK: - product properties
    var productDescription: String!

    /// initializes the product properties using the given product dictionary.
    /// Product dictionary is created after data parsing from webservice.
    override init(productDict:NSDictionary) {
        super.init(productDict: productDict)
        self.productDescription = productDict["description"] as! String
    }

}
