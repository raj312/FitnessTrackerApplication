//
//  GymsNearbyController.swift
//  FitnessTrackerApplication
//
//  Created by DeJoun Robinson on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.

import UIKit
import MapKit
import CoreLocation

class GymsNearbyController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet var mapView: MKMapView!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        //prompts for location access, also requires adding it in Info.plist
        locationManager.requestWhenInUseAuthorization()
        //periodically gets the device location
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //waits for view to appear before searching
        performSearch()
    }
    
    func performSearch() {
        //ensures search matches are clear
        matchingItems.removeAll()
        //initializing mapkit search request object
        let request = MKLocalSearchRequest()
        //specifying search field
        request.naturalLanguageQuery = "Gym"
        //specify search area to map region
        request.region = mapView.region
        
        //create map kit search object with request
        let search = MKLocalSearch(request: request)
        
        //start search
        search.start(completionHandler: {(response, error) in
            if error != nil {
                //print error to console if there is an errror
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                //alert user if no nearby gyms could be found
                self.gymAlert(title: "No Gyms", message: "Unable to find a nearby gym.")
            } else {
                //loops through found matches
                for item in response!.mapItems {
                    
                    self.matchingItems.append(item as MKMapItem)
                    //creates a pin for the gym
                    let annotation = MKPointAnnotation()
                    //specifies location of pin on the map
                    annotation.coordinate = item.placemark.coordinate
                    //puts the gym name in the pin title
                    annotation.title = item.name
                    //adds the pin to the map
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    //gets device location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //location comes as an array but only the first location is required
        let location = locations[0]
        
        //centers the map on the device location
        let center = location.coordinate
        //sets the size and zoom of the map
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        //creates variable to add previous map details to the view
        let region = MKCoordinateRegion(center: center, span: span)
    
        //sets map configuration
        mapView.setRegion(region, animated: true)
        //shows a pulsing blue circle at the device location
        mapView.showsUserLocation = true
    }
    
    //Basic confirmation alert to provide information to the user
    func gymAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
