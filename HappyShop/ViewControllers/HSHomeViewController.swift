//
//  HSHomeViewController.swift
//  HappyShop
//
//  Created by Sanjeev Upreti on 23/04/16.
//  Copyright © 2016 San. All rights reserved.
//

// MARK: - Class Imports
import UIKit

// MARK: - Class HSHomeViewController manages a view that contains basic navigational elements for navigating to a category view.
class HSHomeViewController: UITableViewController {

// MARK: - Properties
    private lazy var categories: [String] = {
        // Categories are stored in Categories.plist file.
        let path = NSBundle.mainBundle().pathForResource("Categories", ofType: "plist")!
        return NSArray(contentsOfFile: path) as! [String]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view's appearance
        self.view.layer.borderColor = UIColor.cyanColor().CGColor
        self.view.layer.borderWidth = 3.0
        self.title = "Home"
        
        HSCartUtility.sharedCartUtility.updateCartStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HSCategoryTableCellIdentifier", forIndexPath: indexPath)
        cell.layoutMargins = UIEdgeInsetsZero

        // Configure the cell
        cell.textLabel?.font = UIFont.systemFontOfSize(17.0)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        if segue.identifier == "HomeToCategory" {
            // If a category is selected, category view will be loaded.
            let destination = segue.destinationViewController as? HSCategoryViewController
            let cell = sender as! UITableViewCell
            let selectedRow = tableView.indexPathForCell(cell)!.row
            destination?.category = categories[selectedRow]
        }
    }
}
