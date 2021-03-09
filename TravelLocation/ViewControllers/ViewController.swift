//
//  ViewController.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 04/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class ViewController: UIViewController {
    
    let tableview : UITableView = {
        let table = UITableView()
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        return table
    }()
    
    var locationViewModel: LocationViewModel!
    var tableViewDatasource: LocationTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locations"
        self.locationViewModel = LocationViewModel(self as? LocationViewModelDelegate)
        self.tableViewDatasource = LocationTableView(self.locationViewModel)
        
        tableview.delegate = self.tableViewDatasource
        tableview.dataSource = self.tableViewDatasource
        tableview.frame = view.bounds
        tableview.rowHeight = 100
        view.addSubview(tableview)
        
        GetBackgroundProcess()
        
    }
    
}

extension ViewController : AddLocationDelegate {
    
    func addLocation(sender:BackgroundLocationManager) {
        
        self.locationViewModel?.getLocationData()
        self.tableview.reloadData()
    }
    
    func GetBackgroundProcess(){
        BackgroundLocationManager.instance.delegate = self
        BackgroundLocationManager.instance.start()
    }
    
}

