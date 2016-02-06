//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import DGActivityIndicatorView

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , UITextFieldDelegate{

    var businesses: NSMutableArray = []
    var searchBar = UISearchBar()
    var filteredBusiness  = []
    let activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.RotatingSquares, tintColor: UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0), size: 70.0)
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = false
        
        retrieve()
        
        // loading view
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        // Pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.retrieve()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 247/255.0, green: 168/255.0, blue: 41/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.sizeToFit()
        
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120 // used for only scroll height dimensions
        
        

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
    
    func retrieve() {
        Business.searchWithTerm(10, term: "Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if nil != businesses{
                self.businesses.addObjectsFromArray(businesses)
            }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.tableView.reloadData()
        })
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredBusiness = []
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
}

extension UIScrollView {
    // to fix a problem where all the constraints of the tableview
    // are deleted
    func dg_stopScrollingAnimation() {}
}
