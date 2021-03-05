//
//  LocationViewModel.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 05/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import Foundation


struct LocationViewModel{
    
    let latitude : Double
    let longitude : Double
    var address : String?
    let timestamp : Date

    
    init(with model: Location){
        latitude = model.latittude
        longitude = model.longitude
        address = model.place
        timestamp = model.timestamp! as Date
    }
    
}
