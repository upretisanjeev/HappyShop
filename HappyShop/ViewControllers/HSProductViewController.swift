//
//  HSProductViewController.swift
//  HappyShop
//
//  Created by Sanjeev Upreti on 23/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import UIKit

// MARK: - Class HSProductViewController manages a view that contain information about 1 specific product, including image. Includes a call ­to ­action button (‘Add to cart’) for users to add product to cart.

class HSProductViewController: UIViewController {

// MARK: - Properties
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var onSaleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!

    var product: Product?
    private var productDetail: ProductDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let product = product else {
            fatalError("product parameter found nil ")
        }
        self.title = product.name

        // fetch product details
        self.fetchProductDetail(product.id)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Action button that allows user to add the current item to cart OR remove the current item from cart
    @IBAction func addToCartButtonTapped(sender: AnyObject) {
        guard let productId = self.productDetail?.id else {
            print("productId found nil")
            return
        }
        
        if HSCartUtility.sharedCartUtility.checkIfItemExistsInCart(productId) {
            self.addToCartButton.setTitle("Add to Cart", forState: .Normal)
            HSCartUtility.sharedCartUtility.removeItemFromCart(productId)
        }
        else {
            self.addToCartButton.setTitle("Remove from Cart", forState: .Normal)
            HSCartUtility.sharedCartUtility.saveItemInCart(productId)
        }
        HSCartUtility.sharedCartUtility.updateCartStatus()
    }

    // MARK: Method for fetching Product details
    /// Method that calls webservice to fetch product details for a given product id.
    ///
    /// After parsing the webservice response, following details are shown for each product: Image, name, price, on sale, description.
    /// "Add to Cart" button title is modified accoringly
    func fetchProductDetail(productId: Int) {
        
        self.activityIndicator.startAnimating()
        self.scrollView.hidden = true
        self.fetchProduct(productId) { (productDetail) -> Void in
            self.activityIndicator.stopAnimating()
            guard let productDetail = productDetail else {
                print("Product details not available")
                return
            }
            self.productDetail = productDetail
            self.productImageView.af_setImageWithURL(NSURL(string: productDetail.img_url)!,
                                                     placeholderImage: UIImage(named: "placeholder"),
                                                     filter: nil,
                                                     imageTransition: .None,
                                                     runImageTransitionIfCached: false,
                                                     completion: nil)
            self.nameLabel.text = productDetail.name
            self.priceLabel.text = HSCartUtility.sharedCartUtility.currencyFormatter.stringFromNumber(productDetail.price)
            self.onSaleLabel.hidden = !productDetail.under_sale
            self.descriptionLabel.text = productDetail.productDescription
            if HSCartUtility.sharedCartUtility.checkIfItemExistsInCart(productId) {
                self.addToCartButton.setTitle("Remove from Cart", forState: .Normal)
            }
            else {
                self.addToCartButton.setTitle("Add to Cart", forState: .Normal)
            }

            self.scrollView.hidden = false
        }

    }

}
