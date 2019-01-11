//
//  ViewPort.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2019-01-08.
//  Copyright © 2019 Prospects. All rights reserved.
//

import Cocoa
import MapKit

class ViewPort: NSObject {

    @objc dynamic var name: String?
    var boundary: [CLLocationCoordinate2D] = []
    var overlay: ViewPortOverlay
    var midCoordinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    var overlayBottomRightCoordinate = CLLocationCoordinate2D()
    var color: NSColor = {
        var color: NSColor?
        var hue: CGFloat = CGFloat(Double(Int(arc4random()) % 256) / 256.0) //  0.0 to 1.0
        var saturation: CGFloat = CGFloat((Double(Int(arc4random()) % 128) / 256.0) + 0.5) //  0.5 to 1.0, away from white
        var brightness: CGFloat = CGFloat((Double(Int(arc4random()) % 128) / 256.0) + 0.5) //  0.5 to 1.0, away from black
        color = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color!
    }()

    var overlayBoundingMapRect: MKMapRect {
        get {
            let topLeft = MKMapPoint(overlayTopLeftCoordinate)
            let topRight = MKMapPoint(overlayTopRightCoordinate)
            let bottomLeft = MKMapPoint(overlayBottomLeftCoordinate)

            return MKMapRect(
                x: topLeft.x,
                y: topLeft.y,
                width: fabs(topLeft.x - topRight.x),
                height: fabs(topLeft.y - bottomLeft.y))
        }
    }

    init(name: String, northEst: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D)
    {
        self.name = name
        overlayTopRightCoordinate = northEst
        overlayBottomLeftCoordinate = southWest
        overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: northEst.latitude, longitude: southWest.longitude)
        overlayBottomRightCoordinate = CLLocationCoordinate2D(latitude: southWest.latitude, longitude: northEst.longitude)
        midCoordinate = ViewPort.middlePointOfListMarkers(listCoords: [southWest, northEst])
        boundary = [overlayTopLeftCoordinate, overlayTopRightCoordinate, overlayBottomRightCoordinate, overlayBottomLeftCoordinate]
        self.overlay = ViewPortOverlay(coordinates: self.boundary, count: self.boundary.count)
        self.overlay.color = self.color

    }

    //        /** Degrees to Radian **/
    class func degreeToRadian(angle:CLLocationDegrees) -> Double {
        return (  (Double(angle)) / 180.0 * Double.pi  )
    }

    //        /** Radians to Degrees **/
    class func radianToDegree(radian:Double) -> CLLocationDegrees {
        return CLLocationDegrees(  radian * Double(180.0 / Double.pi)  )
    }

    class func middlePointOfListMarkers(listCoords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {

        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat

        for coordinate in listCoords{
            let lat:Double = degreeToRadian(angle: coordinate.latitude)
            let lon:Double = degreeToRadian(angle: coordinate.longitude)
            x = x + CGFloat(cos(lat) * cos(lon))
            y = y + CGFloat(cos(lat) * sin(lon))
            z = z + CGFloat(sin(lat))
        }

        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)

        let resultLon: CGFloat = atan2(y, x)
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        let resultLat:CGFloat = atan2(z, resultHyp)

        let newLat = radianToDegree(radian: Double(resultLat))
        let newLon = radianToDegree(radian: Double(resultLon))
        let result:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)

        return result

    }
    
}

