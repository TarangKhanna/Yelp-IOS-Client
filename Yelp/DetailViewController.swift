//
//  DetailViewController.swift
//  Yelp
//
//  Created by Tarang khanna on 2/6/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var addressLabel: UILabel!
    
   
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = business.name!
        print(business.name)
        let reviewCount = self.business.reviewCount!
        if (reviewCount == 1) {
            self.reviewLabel.text = "\(reviewCount) review"
        } else {
            self.reviewLabel.text = "\(reviewCount) reviews"
        }
        
        self.addressLabel.text = self.business.address
        self.categoriesLabel.text = self.business.categories
        
        
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.business.latitude!, longitude: self.business.longitude!)
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        self.mapView.layer.cornerRadius = 9.0
        self.mapView.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = false
        }
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
