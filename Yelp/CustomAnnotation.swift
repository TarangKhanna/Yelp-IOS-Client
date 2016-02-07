//
//  CustomAnnotation.swift
//  Yelp
//
//  Created by Tarang khanna on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}