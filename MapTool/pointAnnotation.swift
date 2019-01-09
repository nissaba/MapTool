//
//  pointAnnotation.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2019-01-08.
//  Copyright © 2019 Prospects. All rights reserved.
//

import Cocoa
import MapKit

class pointAnnotation: NSObject, MKAnnotation
{
    @objc dynamic var label: String
    @objc dynamic var location: String
    var coordinate:CLLocationCoordinate2D { return coord }
    internal var coord:CLLocationCoordinate2D

    init(_ label: String, coordinate:CLLocationCoordinate2D)
    {
        self.label = label
        self.coord = coordinate
        self.location = "\(coordinate.latitude),\(coordinate.longitude)"
        super.init()
    }
}
