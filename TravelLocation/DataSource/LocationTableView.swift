//
//  PersonTableView.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 09/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import UIKit


class LocationTableView: NSObject, UITableViewDataSource , UITableViewDelegate {
    
    let locationViewModel: LocationViewModel
    
    init(_ locationViewModel: LocationViewModel) {
        self.locationViewModel = locationViewModel
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationViewModel.numberOfLocations()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        let locationViewModel = self.locationViewModel.location(atIndex: indexPath.row)
        cell.configure(with: locationViewModel)
        
        return cell
    }
}
