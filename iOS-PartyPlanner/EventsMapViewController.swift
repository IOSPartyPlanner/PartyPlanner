//
//  EventsMapViewController.swift
//  iOS-PartyPlanner
//
//  Created by Tugce Keser on 5/6/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AFNetworking

class EventsMapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    //TODO: Current Location is not working
    var locationManager : CLLocationManager!
    var events : [Event]?
     var editedImage : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 5
        locationManager.requestWhenInUseAuthorization()
        pinEvents()
      
    }
    
    func pinEvents(){
        for event in events! {
            addAnnotationAtAddress(address: event.location!, title: event.name!, imageURL: NSURL(string:event.inviteMediaUrl!) as! URL)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    
    // add an annotation with an address: String
    func addAnnotationAtAddress(address: String, title: String, imageURL:URL) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.editedImage?.setImageWith(imageURL)
                    print(imageURL)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(_ viewFormapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        
        let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = .scaleAspectFit
        resizeRenderImageView.image = editedImage?.image
        
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = resizeRenderImageView.image
        
        let rightButton = UIButton(type: UIButtonType.detailDisclosure);
        //rightButton.addTarget(self, action: Selector("buttonTapped:"), for: UIControlEvents.touchUpInside)
        annotationView?.rightCalloutAccessoryView = rightButton;
        
        /*let button = annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
         button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)*/
        
        return annotationView
    }

}
