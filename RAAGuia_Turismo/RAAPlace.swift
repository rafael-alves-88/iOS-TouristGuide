//
//  RAAPlace.swift
//  RAAGuia_Turismo
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Usuário Convidado. All rights reserved.
//

import UIKit

class RAAPlace: NSObject {

    func Place() {
        Name = ""
        Address = ""
        ImageURL = ""
        Coordinates = RAACoordinate()
    }
    
    var Name: String?
    var Address: String?
    var ImageURL: String?
    var Coordinates: RAACoordinate?
}
