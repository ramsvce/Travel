//
//  LocationViewModel.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 05/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import UIKit
import CoreData


protocol LocationViewModelDelegate: AnyObject {
}

class LocationViewModel{
    
    weak var delegate: LocationViewModelDelegate?
    
    private (set) var locations: [Location] = []
    
    init(_ delegate: LocationViewModelDelegate?) {
        self.delegate = delegate
        self.locations = [Location]()
    }
    
    func getLocationData(){
        
        let result = LocationHelpers().fetchLocation()
        self.locations = result
    }
    
    func numberOfLocations() -> Int {
        return self.locations.count
    }
    
    func location(atIndex index: Int) -> LocationVM {
        return LocationVM(self.locations[index])
    }
    
}


