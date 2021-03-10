//
//  DateFormat.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 09/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import Foundation

class DateFormat {
    
    func formatDate(date: NSDate) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
}




