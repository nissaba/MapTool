//
//  ViewPortOverlay.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2019-01-08.
//  Copyright © 2019 Prospects. All rights reserved.
//

import Cocoa
import MapKit

class ViewPortOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect

    init(viewPort: ViewPort)
    {
        boundingMapRect = viewPort.overlayBoundingMapRect
        coordinate = viewPort.midCoordinate
    }
}
