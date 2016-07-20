//
//  HSCategoryViewController.swift
//  HappyShop
//
//  Created by Sanjeev Upreti on 22/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import UIKit

// MARK: - Class HSCategoryViewController manages view to display the products for a particular category.
class HSCategoryViewController: UICollectionViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    private let reuseIdentifier = "HSProductCollectionCellIdentifier"
    private let productCellMargin          = 10.0
    private let productCellSpacing         = 10.0
    private let productCellTextAreaHeight  = 50.0
    private var products = [Product]()
    private var fetchingProductsInProgress = false
    private var productListExhausted = false
    private var lastPage = 1
    var category:String?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category

        // Add activityIndicator to the view
        self.view.addSubview(self.activityIndicator)

        // Configure the activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = UIColor.blackColor()

        // fetch products
        self.fetchProducts(category, page: lastPage)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "CategoryToProduct" {
            // If a product is selected, the product view will be loaded.
            let destination = segue.destinationViewController as? HSProductViewController
            let cell = sender as! ProductCollectionCell
            let selectedRow = collectionView!.indexPathForCell(cell)!.row
            let product = products[selectedRow]
            destination?.product = product
        }

    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProductCollectionCell

    
        // Configure the cell
        let product = products[indexPath.row]
        cell.name.text = product.name
        cell.price.text = HSCartUtility.sharedCartUtility.currencyFormatter.stringFromNumber(product.price)

        cell.onSale.hidden = !product.under_sale
        cell.productImageView?.af_setImageWithURL(NSURL(string: product.img_url)!,
                                           placeholderImage: UIImage(named: "placeholder"),
                                           filter: nil,
                                           imageTransition: .None,
                                           runImageTransitionIfCached: false,
                                           completion: nil)

        return cell
    }
    
    // MARK:  UICollectionViewDelegateFlowLayout

    
     func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Cell width is half of the screen width - edge margin - half the center margin
        let width = (self.collectionView!.frame.size.width / 2.0.cgf) - productCellMargin.cgf - (productCellSpacing.cgf / 2.0.cgf)
        return CGSizeMake(width, width + productCellTextAreaHeight.cgf)

    }

    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(productCellMargin.cgf, productCellMargin.cgf, productCellMargin.cgf, productCellMargin.cgf)

    }
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return productCellSpacing.cgf

    }
    
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return productCellSpacing.cgf
    }
 
    // MARK: Scroll delegates
  
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard scrollView.tracking && !productListExhausted && !fetchingProductsInProgress else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            // User has dragged till bottom, fetch more products.
            // Request to the API should be paginated as user scrolls.
            self.fetchProducts(category, page: lastPage)
        }
    }
    
    // MARK: Method for fetching Products
    /// Method that calls webservice to fetch products of given category at a given page.
    ///
    /// After parsing the webservice response, following details are shown for each product: Image, name, price, on sale
    func fetchProducts(category: String?, page: Int) {
        guard !productListExhausted && !fetchingProductsInProgress else {
            return
        }
        fetchingProductsInProgress = true
        self.activityIndicator.startAnimating()
        self.fetchProducts(category, page: page) { (products) -> Void in
            self.fetchingProductsInProgress = false
            self.activityIndicator.stopAnimating()

            guard let products = products else {
                print("No products available")
                return
            }

            guard products.count != 0 else {
                print("Product List exhausted")
                self.productListExhausted = true
                return
            }

            self.lastPage += 1
            self.products.appendContentsOf(products)
            // reload data in collectionView
            self.collectionView!.reloadData()
        }

    }
}

// MARK: - Class ProductCollectionCell is a custom collection cell to display product details
class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var onSale: UILabel!
}

