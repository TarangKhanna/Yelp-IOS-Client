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
import ElasticTransition

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , UITextFieldDelegate{

    var didSegue : Bool = false
    var pages = 0
    var originalSize = 0
    var searchActive : Bool = false
    var businesses: NSMutableArray = []
    var searchBar = UISearchBar()
    var filteredBusiness  = []
    let activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.RotatingSquares, tintColor: UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0), size: 70.0)
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    @IBOutlet weak var tableView: UITableView!
    
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchActive = false
        
        // custom transition
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .TranslateMid
        transition.edge = .Right
        navigationController?.delegate = transition
        
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
        tableView.dg_setPullToRefreshFillColor(UIColor.redColor())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        // navigation bar customization
        navigationItem.titleView = searchBar
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.sizeToFit()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120 // used for only scroll height dimensions
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    func loadMoreData() {
        Business.searchWithTerm(pages*originalSize, term: "Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if nil != businesses{
                self.businesses.addObjectsFromArray(businesses)
            }
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    func retrieve() {
        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if nil != businesses{
                self.businesses.addObjectsFromArray(businesses)
            }
            self.originalSize = businesses.count
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
        if searchText.characters.count > 0 {
            searchActive = true
        } else {
            searchActive = false
            //            searchBar.resignFirstResponder()
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredBusiness = []
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        searchBar.showsCancelButton = false
        searchActive = false
    }
    
    // Infinite scroll
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                self.pages += 1
                loadMoreData()
                // ... Code to load more results ...
            }
            // ... Code to load more results ...
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        self.performSegueWithIdentifier("details", sender: currentCell)
        searchBar.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let row = tableView.indexPathForCell(cell)!.row
            if segue.identifier == "details" {
                let vc = segue.destinationViewController as! DetailViewController
                if searchActive && filteredBusiness.count > 0 || didSegue && filteredBusiness.count > 0 {
                    print("searchActive")
                    let business = filteredBusiness[row]
                    didSegue = true
                    vc.business = business as! Business
                } else {
                    let business = businesses[row]
                    vc.business = business as! Business
                }
            }
        }

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
         searchBar.showsCancelButton = false
         searchActive = false
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
