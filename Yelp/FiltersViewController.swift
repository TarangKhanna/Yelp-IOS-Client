//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Tarang khanna on 2/6/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String:String]]!

    override func viewDidLoad() {
        super.viewDidLoad()
//        categories = 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
