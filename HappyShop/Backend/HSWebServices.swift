//
//  HSWebServices.swift
//  HappyShop
//
//  Created by Sanjeev on 21/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import Foundation
import Alamofire
import AlamofireImage

// MARK: - WebService Constants
let BASE_URL = "http://sephora-mobile-takehome-2.herokuapp.com/api/v1/"
let PRODUCTS_END_POINT = "products.json"
let PRODUCT_DETAIL_END_POINT = "products/%@.json" // provide product-Id

// MARK: - WebService methods are added as extension on UIViewController
extension UIViewController {
    
    /// WebService to fetch product details for the given product Id.
    func fetchProduct(id: Int?, completion: (ProductDetail?) -> Void) {
        guard let id = id else {
            print("id parameter found nil in fetchProduct")
            completion(nil)
            return
        }
        
        let requestUrl = BASE_URL + String(format: PRODUCT_DETAIL_END_POINT, String(id))
        Alamofire.request(
            .GET,
            requestUrl,
            parameters:  nil,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in

                guard response.result.isSuccess else {
                    print("Error while fetching product: \(response.result.error)")
                    self.showAlert(response.result.error?.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: AnyObject],
                    productDict = value["product"] as? [String: AnyObject] else {
                        print("Malformed data received from fetchProduct web service")
                        completion(nil)
                        return
                }
                
                let product = ProductDetail(productDict: productDict)
                
                completion(product)
        }
    }
    
    /// WebService to fetch products for the given category and page.
    /// p​age parameter is used ​to paginate products by sets of 10.
    func fetchProducts(category: String?, page: Int?, completion: ([Product]?) -> Void) {
        
        guard let category = category else {
            print("category parameter found nil in fetchProducts")
            completion(nil)
            return
        }
        guard let page = page else {
            print("page parameter found nil in fetchProducts")
            completion(nil)
            return
        }
        
        let requestUrl = BASE_URL + PRODUCTS_END_POINT
        Alamofire.request(
            .GET,
            requestUrl,
            parameters: ["category": category, "page": String(page)],
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching products: \(response.result.error)")
                    self.showAlert(response.result.error?.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: AnyObject],
                    rows = value["products"] as? [[String: AnyObject]] else {
                        print("Malformed data received from fetchProducts web service")
                        completion(nil)
                        return
                }
                

                var products = [Product]()
                for productDict in rows {
                    products.append(Product(productDict: productDict))
                }
                
                completion(products)
        }
    }
}
