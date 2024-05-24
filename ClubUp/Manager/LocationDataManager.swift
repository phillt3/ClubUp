//
//  LocationDataManager.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/21/24.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate {
   var locationManager = CLLocationManager()

   override init() {
      super.init()
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
   }
    
    public func requestOneTimeLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error: \(error.localizedDescription)")
    }

}
