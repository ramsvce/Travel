//
//  BackgroundLocationManager.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 04/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


protocol AddLocationDelegate : AnyObject {
    func addLocation(sender : BackgroundLocationManager)
}

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {
    
    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 200.0 // restart location manager every 150 seconds
    static let UPDATE_SERVER_INTERVAL = 60 * 10 // 1 hour - once every 1 hour send location to server
    
    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()
    
    weak var delegate : AddLocationDelegate?
    private var viewModel : LocationViewModel?
    
    
    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        if #available(iOS 9, *){
            locationManager.allowsBackgroundLocationUpdates = true
        }
        
         if UIApplication.shared.applicationState == .active {
             print("AAAAActive")
         }else{
            
              NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        }
    }
    
    @objc func applicationEnterBackground(){
        start()
    }
    
    func stop(){
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        
        timer?.invalidate()
        timer = nil
        
        if self.currentBgTaskId != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(self.currentBgTaskId!)
            self.currentBgTaskId = UIBackgroundTaskInvalid
        } else { return }
        
    }
    
    func start(){
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    @objc func restart (){
        
        print("restart")
        timer?.invalidate()
        timer = nil
        start()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted: break
        case CLAuthorizationStatus.denied: break
        case CLAuthorizationStatus.notDetermined: break
        default:
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(timer==nil){
            guard let location = locations.last else {return}
            
            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = Date()
            if(isItTime(now: now)){
                print("sendLocationToServer")
                sendLocationToServer(location: location, now:now)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()
    }
    
    
    func isItTime(now:Date) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate as Date)
        let intervalExceeded = Int(timePast) > BackgroundLocationManager.UPDATE_SERVER_INTERVAL
        return intervalExceeded;
    }
    
    fileprivate var str : String?
    
    func sendLocationToServer(location:CLLocation, now:Date){
        //TODO
        
        self.str = ""

        convertLatLongToAddress1(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] locationName in
            self?.str  = locationName!
            
            print("New address is \(String(describing: self?.str))")
            
            LocationHelpers().addLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, place: locationName!, timestamp: now)
            
            if UIApplication.shared.applicationState == .inactive{
                print("Suspended")
                self?.stop()
            }else{
                self?.delegate?.addLocation(sender: self!)
            }
            print("New address is Completed")

        }
        
    }
    
   
    
    func convertLatLongToAddress1(latitude:Double,longitude:Double ,
                                  completion : @escaping ((String?) -> (Void))){

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            var addr = ""
         
            // Street address
            if let street = placeMark.thoroughfare {
                addr +=  street
            }
            // City
            if let city = placeMark.locality {
                addr += " - " + city
            }
            // State
            if let state = placeMark.administrativeArea {
                addr += " - " + state
            }
            // Zip code
            if let zipCode = placeMark.postalCode {
                addr += " - " + String(describing: zipCode)
            }
            // Country
            if let country = placeMark.country {
                addr += " - " + String(describing: country)
            }
            
            completion(addr)
        }

    }
    
    
    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
        
        currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
        })
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskInvalid
        }
        timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart), userInfo: nil, repeats: false)
        
        print(BackgroundLocationManager.BACKGROUND_TIMER)

    }
}
