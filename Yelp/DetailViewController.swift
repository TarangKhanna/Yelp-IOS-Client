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
    
    @IBOutlet weak var ratingView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var picView: UIImageView!
    
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if business != nil {
            
            self.navigationItem.title = business.name!
            print(business.name)
            let reviewCount = self.business.reviewCount!
            if (reviewCount == 1) {
                self.reviewLabel.text = "\(reviewCount) review"
            } else {
                self.reviewLabel.text = "\(reviewCount) reviews"
            }
            
            if (self.business.imageURL != nil) {
                self.picView.setImageWithURL(business.imageURL!)
            }
            
            self.ratingView.setImageWithURL(business.ratingImageURL!)
            
            self.picView.layer.cornerRadius = 9.0
            self.picView.layer.masksToBounds = true
            
            self.addressLabel.text = self.business.address
            self.categoriesLabel.text = self.business.categories
            
            
            self.mapView.delegate = self
            let coordinate = CLLocationCoordinate2D(latitude: self.business.latitude!, longitude: self.business.longitude!)
            let annotation = CustomAnnotation(title: business.name!,
                locationName: business.categories!,
                discipline:  business.name!,
                coordinate: coordinate)
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        } else {
            
        }
        // Do any additional setup after loading the view.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure) as UIView
            }
            return view
        }
        return nil
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
