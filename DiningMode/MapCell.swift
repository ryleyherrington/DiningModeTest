//
//  MapCell.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/27/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
import MapKit

public let MapCellReuseId = "mapCell"

class MapCell: UICollectionViewCell {
    var reservation:Reservation!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0,
                              y: self.addressLabel.frame.origin.y))
        
        path.addLine(to: CGPoint(x:self.frame.size.width,
                                 y:self.addressLabel.frame.origin.y))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
    }
    
    //I will say that there is a weird bug regarding map views
    //Reference: http://stackoverflow.com/a/39769891/4855567 or http://stackoverflow.com/questions/39611554/upgrade-xcode8-with-swift3-0
    func updateModel(){
        let initialLocation = reservation.restaurant.location
        centerMapOnLocation(location: initialLocation, radius: 2000)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate 
        annotation.title = reservation.restaurant.name
        map.addAnnotation(annotation)
        
        addressLabel.text = reservation.restaurant.street
    }
    
    func centerMapOnLocation(location: CLLocation, radius:CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2.0, radius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
}
