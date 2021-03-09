//
//  LocationTableViewCell.swift
//  TravelLocation
//
//  Created by ramesh pazhanimala on 05/03/21.
//  Copyright © 2021 ramesh pazhanimala. All rights reserved.
//

import UIKit


class LocationTableViewCell: UITableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    private let coordinateLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 15.0)
        
        return label
    }()
    
    private let addressLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coordinateLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(dateLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with viewModel : LocationVM){
        coordinateLabel.text = "Lat : \(viewModel.latitude) - " +  "Long : \(viewModel.longitude)"
        dateLabel.text = "Date : \(String(describing: viewModel.timestamp))"
        addressLabel.text = viewModel.address
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addressLabel.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width , height: contentView.frame.size.height/2 - 20)
        addressLabel.numberOfLines = 2
        coordinateLabel.frame = CGRect(x: 5, y: contentView.frame.size.height/2 - 15, width: contentView.frame.size.width, height: 30)
        dateLabel.frame = CGRect(x: 5, y: contentView.frame.size.height/2 + 10, width: contentView.frame.size.width, height: 30)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLabel.text = nil
        coordinateLabel.text = nil
        dateLabel.text = nil
        
    }
    
}

