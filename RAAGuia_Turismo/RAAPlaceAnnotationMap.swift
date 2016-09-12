//
//  RAAPlaceAnnotationMap.swift
//  RAAGuia_Turismo
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Usuário Convidado. All rights reserved.
//

import UIKit
import MapKit

class RAAPlaceAnnotationMap: NSObject {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var mapItem: MKMapItem?
    var imageURL: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, mapItem: MKMapItem, imageURL: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.mapItem = mapItem
        self.imageURL = imageURL
    }
}
