//
//  RAAMapViewController.swift
//  RAAGuia_Turismo
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Usuário Convidado. All rights reserved.
//

import UIKit
import MapKit

class RAAMapViewController: UIViewController, MKMapViewDelegate {
    
    var session: NSURLSession?
    var arrPlaces: [RAAPlace] = []
    let locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: sessionConfig)
        
        self.getUserLocation()
        self.createCatedralDaSeLocation()
        self.getJSON()
    }
    
    func getJSON() {
        let url = NSURL (string:"http://flameworks.com.br/fiap/pontosTuristicos.txt")!
        
        let task = session!.dataTaskWithURL(url, completionHandler: {(data: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            if(error == nil) {
                let retStr: String = String(data: data!, encoding: NSUTF8StringEncoding)!
                print(retStr)
                
                self.getPlaces(data!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    //self.label.text = appName
                    //self.downloadImage(imageURL)
                })
            } else {
                print(error?.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    func getPlaces(data: NSData) {
        
        // Clean PlacesArray
        arrPlaces = []
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            // Get JSON
            if let locais = json["locais"] as? [[String: AnyObject]] {
                
                // Iterate in Dictionary Array
                for local in locais {
                    
                    // Create a new Place
                    let newPlace:RAAPlace = RAAPlace()
                    
                    // Get Name
                    if let nome = local["nome"] as? String {
                        newPlace.Name = nome
                    }
                    
                    // Get Address
                    if let address = local["endereco"] as? String {
                        newPlace.Address = address
                    }
                    
                    // Get Image
                    if let image = local["imagem"] as? String {
                        newPlace.ImageURL = image
                    }
                    
                    // Get Coordinates
                    if let coordinates = local["coordenadas"] as? [String: AnyObject] {
                        // Create new Coordinate
                        let coordinate = RAACoordinate()
                        
                        // Get Latitude
                        if let latitude = coordinates["lat"] as? Double {
                            coordinate.Latitude = latitude
                        }
                        // Get Longitude
                        if let longitude = coordinates["lon"] as? Double {
                            coordinate.Longitude = longitude
                        }
                        
                        newPlace.Coordinates = coordinate
                    }
                    
                    // Append New Place to PlacesArray
                    arrPlaces.append(newPlace)
                }
                
                setPlacesOnMap(arrPlaces)
            }
        } catch {
            print("Erro ao parser JSON")
        }
    }
    
    func getUserLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
    }
    
    func createCatedralDaSeLocation() {
        let seLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.550303, -46.634184)
        
        self.mapView.region = MKCoordinateRegionMakeWithDistance(seLocation, 1200, 1200)
        
        let sePlace: RAAPlace = RAAPlace()
        sePlace.Name = "Catedral Da Sé"
        sePlace.Address = "Praça da Sé, 88, São Paulo, SP, Brasil"
        sePlace.ImageURL = "http://flameworks.com.br/fiap/catedraldase.png"
        let coordinate = RAACoordinate()
        coordinate.Latitude = -23.550303
        coordinate.Longitude = -46.634184
        sePlace.Coordinates = coordinate
        
        drawOnMap(sePlace)
    }
    
    func drawOnMap(place: RAAPlace) {
        let latitude: Double = place.Coordinates!.Latitude!
        let longitude: Double = place.Coordinates!.Longitude!
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let placeAnnotation = RAAPlaceAnnotation(coordinate: location, title: place.Name!, subtitle: place.Address!, imageURL: place.ImageURL!)
        
        self.mapView.addAnnotations([placeAnnotation])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setPlacesOnMap(arrPlaces: [RAAPlace]) {
        for place in arrPlaces {
            drawOnMap(place)
        }
    }
    
    @IBAction func MapType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.mapView.mapType = MKMapType.Standard
            case 1:
                self.mapView.mapType = MKMapType.Satellite
            case 2:
                self.mapView.mapType = MKMapType.Hybrid
            default:
                self.mapView.mapType = MKMapType.Standard
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is RAAPlaceAnnotation {
            //verificar se a marcação já existe para tentar reutilizá-la!
            let reuseId = "reusePlaceAnnotation"
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                //trocar a imagem pelo pino azul
                anView!.image = UIImage(named:"bluePin")
                
                anView!.canShowCallout = true
                anView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            }
            
            return anView
        }
        
        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        self.performSegueWithIdentifier("placeToDetailSegue", sender:view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "placeToDetailSegue") {
            let vc:RAADetailViewController = segue.destinationViewController as! RAADetailViewController
            vc.annotation = sender?.annotation
        }
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
