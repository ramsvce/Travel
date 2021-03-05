//
//  Location+CoreDataProperties.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 04/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latittude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var place: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var id: Int16

}
