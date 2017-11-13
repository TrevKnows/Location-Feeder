//
//  ViewController.swift
//  Location Feeder
//
//  Created by Trevor Beaton on 7/6/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation!.self
    var userLatitude:Double!
    var userLongitude:Double!
   
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
                    
}

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.03, 0.0)
        
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

        let region = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
        latLabel.text = "\(location.speed)"
        
        
        if let locations = locations.first {
            //print(locations.coordinate)
            print("Latitude: \(locations.coordinate.latitude)")
            print("Longitude: \(locations.coordinate.longitude)")
            self.userLatitude = locations.coordinate.latitude
            self.userLongitude = locations.coordinate.longitude
            self.postLocation()
     
        }
    
    }

    
    
    func postLocation() {
        
        let parameters = ["value": "nil", "lat": "\(String(format: "%e", (userLatitude)))", "lon": "\(String(format: "%e", (userLongitude)))"]
        
        
        guard let url = URL(string: "https://io.adafruit.com/api/feeds/location-feed/data.json?X-AIO-Key=c04d002a910e4eff85e6b83203d4e287") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }

    
    
    
    

}
