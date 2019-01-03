//
//  ViewController.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2018-12-27.
//  Copyright © 2018 Prospects. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController, NSTableViewDelegate, MKMapViewDelegate, NewOverlayViewControllerDelegate {

    @IBOutlet weak var latTextField: NSTextField!
    @IBOutlet weak var longTextField: NSTextField!
    @IBOutlet var overlayController: NSArrayController!
    @IBOutlet var annotationController: NSArrayController!
    @IBOutlet var annotationsTableView: NSTableView!
    @IBOutlet var mapView: MKMapView!
    var annotations: [pointAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        annotationController.content = annotations
        // Do any additional setup after loading the view.
        updateMenu()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addOverlaySegue"
        {
            let dest = segue.destinationController as! NewOverlayViewController
            dest.delegate = self
        }
    }

    func didAddViewPort(north: Double, est: Double, south: Double, west: Double) {

    }

    func updateMenu()
    {
        if let appDel = NSApplication.shared.delegate as? AppDelegate
        {
            appDel.updateMenuItems(removePin: annotationsTableView.numberOfSelectedRows > 0,
                                   removeAllPins: annotations.count > 0,
                                   addOverlay: false,
                                   removeOverlay: false,
                                   removeAllOverlay: false)
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        updateMenu()
    }

    @IBAction func addAnnotation(_ sender: Any) {
        let lat = Double(self.latTextField.stringValue)
        let long = Double(self.longTextField.stringValue)
        let annot = pointAnnotation("Anotation #\(self.annotations.count)", coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
        annotations.append(annot)
        mapView.addAnnotation(annot)
        annotationController.content = annotations
        updateMenu()
    }

    @IBAction func clearPins(_ sender: Any)
    {
        annotations = []
        annotationController.content = annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        updateMenu()
    }

    @IBAction func deleteSelectedPin(_ sender: Any)
    {
        var toRemove:[pointAnnotation] = []
        for index in annotationsTableView.selectedRowIndexes
        {
            toRemove.append(annotations[index])
        }
        let toKeep = annotations.compactMap { annot -> (pointAnnotation?) in
            if let _ = toRemove.firstIndex(of: annot)
            {
                return nil
            }
            return annot
        }

        annotations = toKeep
        annotationController.content = annotations
        self.mapView.removeAnnotations(toRemove)
        updateMenu()
    }
}

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
