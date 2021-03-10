//
//  LocationVM.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 09/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import Foundation


class LocationVM: NSObject {
    private var location: Location
    init(_ location: Location) {
        self.location = location
    }
    
    var latitude: Double {
        get {
            return self.location.latittude
        }
    }
    
    var longitude: Double {
        get {
            return self.location.longitude
        }
    }
    
    var address: String {
        get {
            return self.location.place!
        }
    }
    
    var timestamp: String {
        get {
            return DateFormat().formatDate(date: self.location.timestamp! )
        }
    }
    
}
