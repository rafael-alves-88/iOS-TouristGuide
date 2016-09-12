//
//  RAAPlaceAnnotation.swift
//  RAAGuia_Turismo
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Usuário Convidado. All rights reserved.
//

import UIKit
import MapKit

class RAAPlaceAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageURL: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageURL: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}
