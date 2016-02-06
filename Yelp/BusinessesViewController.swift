//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , UITextFieldDelegate{

    var businesses: NSMutableArray = []
    var searchBar = UISearchBar()
    var filteredBusiness  = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.sizeToFit()
        
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120 // used for only scroll height dimensions
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if nil != businesses{
                self.businesses.addObjectsFromArray(businesses)
            }
                self.tableView.reloadData()
            self.tableView.reloadData()
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusiness.count != 0 {
            return filteredBusiness.count
        } else {
            return businesses.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        if filteredBusiness.count != 0 {
            cell.business = filteredBusiness[indexPath.row] as! Business
        } else {
            // encapsulate data
            cell.business = businesses[indexPath.row] as! Business
        }
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        print("here")
        if searchText.isEmpty {
            filteredBusiness = businesses
        } else {
            let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            let filteredArray = businesses.filteredArrayUsingPredicate(searchPredicate)
            if filteredArray.count != 0 {
                filteredBusiness = filteredArray
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredBusiness = []
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
        
    }

}
