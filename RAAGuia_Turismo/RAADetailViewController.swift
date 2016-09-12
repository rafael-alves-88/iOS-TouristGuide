//
//  RAADetailViewController.swift
//  RAAGuia_Turismo
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Usuário Convidado. All rights reserved.
//

import UIKit
import MapKit

class RAADetailViewController: UIViewController {
    
    var annotation: AnyObject?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotationMap: RAAPlaceAnnotation = self.annotation as! RAAPlaceAnnotation
        self.labelTitle.text = annotationMap.title!
        self.labelAddress.text = annotationMap.subtitle!
        
        if let checkedUrl = NSURL(string: annotationMap.imageURL!) {
            image.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL) {
        loadingIndicator.startAnimating()
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.image.image = UIImage(data: data)
                self.loadingIndicator.stopAnimating()
            }
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
