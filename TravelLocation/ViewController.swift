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


class ViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = Location.fetchRequest() as NSFetchRequest<Location>
    
    private var items = [Location]()

    let tableview : UITableView = {
       let table = UITableView()
        return table
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        let location = self.items[indexPath.row]
        cell.configure(with: LocationViewModel(with: location))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BackgroundLocationManager.instance.delegate = self
       
//        initializeLocation()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.bounds
        tableview.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        let barbutton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startTracking))
         let barbutton2 = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopTracking))
        
        self.navigationItem.leftBarButtonItem = barbutton
        self.navigationItem.rightBarButtonItem = barbutton2
        view.addSubview(tableview)
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
       
        fetchLocation()
        
    }
    
    @objc func startTracking(){
         BackgroundLocationManager.instance.delegate = self
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        BackgroundLocationManager.instance.start()

    }
    
    @objc func stopTracking(){
        BackgroundLocationManager.instance.delegate = nil
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        BackgroundLocationManager.instance.stop()
    }

}

extension ViewController : AddLocationDelegate {
    
    func addLocation(sender:BackgroundLocationManager) {

        fetchLocation()
    }
    
    public func initializeLocation(){
        
        self.items = try! context.fetch(request)
        let counter = self.items.count
        
        for i in 0..<counter-1 {
            let newPerson = self.items[i]
            self.context.delete(newPerson)
            try! self.context.save()
        }
    }
    
    func fetchLocation(){
        
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        self.request.sortDescriptors = [sort]
        
        self.items = try! self.context.fetch(self.request)
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
        
}

