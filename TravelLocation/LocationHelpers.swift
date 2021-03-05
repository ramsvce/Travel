//
//  LocationHelpers.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 05/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import UIKit
import CoreData

class LocationHelpers {
    
    var items:[Location]? = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = Location.fetchRequest() as NSFetchRequest<Location>

    public func addLocation( latitude :Double , longitude : Double , place: String , timestamp : Date ){
        
        do{
            
            self.items = try! context.fetch(request)
            
            let newLocation = Location(context: self.context)
            newLocation.latittude = latitude
            newLocation.longitude = longitude
            newLocation.place = place
            newLocation.timestamp = timestamp as NSDate
            
            try self.context.save()

        }
        catch{
            print("error")
            
        }
    }
    
    
    
}

