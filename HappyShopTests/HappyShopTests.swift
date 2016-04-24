//
//  HappyShopTests.swift
//  HappyShopTests
//
//  Created by Sanjeev on 20/04/16.
//  Copyright © 2016 San. All rights reserved.
//

import XCTest
@testable import HappyShop

class HappyShopTests: XCTestCase {
    
    func testHSCartUtilityToSaveAndRemoveAnItem() {
        // given
        let productId = 17
        let sharedCartUtility = HSCartUtility.sharedCartUtility
        
        // when
        sharedCartUtility.removeItemFromCart(productId)
        XCTAssertFalse(sharedCartUtility.checkIfItemExistsInCart(productId))
        sharedCartUtility.saveItemInCart(productId)
        
        // then
        XCTAssertNotNil(sharedCartUtility.itemsIdInCart())
        XCTAssertTrue(sharedCartUtility.checkIfItemExistsInCart(productId))
    }

    func testFetchProductsWebService() {
        // given
        let page = 1
        let category = "Skincare"
        
        // when
        let categoryViewController = HSCategoryViewController()
        categoryViewController.fetchProducts(category, page: page) { (products) in
            
            // then
            XCTAssertNotNil(products)
            let product = products![0]
            XCTAssertTrue(product.category == category)
        }
    }

    func testFetchProductWebService() {
        // given
        let productId = 17
        
        // when
        let productViewController = HSProductViewController()
        productViewController.fetchProduct(productId) { (productDetail) in
            
            // then
            XCTAssertNotNil(productDetail)
            XCTAssertTrue(productDetail?.id == productId)
        }
    }
}
