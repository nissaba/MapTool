//
//  ViewController.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2018-12-27.
//  Copyright © 2018 Prospects. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController, NSTableViewDelegate, NewOverlayViewControllerDelegate {

    @IBOutlet weak var latTextField: NSTextField!
    @IBOutlet weak var longTextField: NSTextField!
    @IBOutlet var overlayController: NSArrayController!
    @IBOutlet var annotationController: NSArrayController!
    @IBOutlet var overlayTable: NSTableView!
    @IBOutlet var annotationsTableView: NSTableView!
    @IBOutlet var mapView: MKMapView!
    var annotations: [pointAnnotation] = []
    var viewPorts: [ViewPort] = []

    //MARK: -
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

    func didAddViewPort(north: Double, est: Double, south: Double, west: Double)
    {
        let newViewPort: ViewPort = ViewPort(name: "VP: #\(viewPorts.count)",
            northEst: CLLocationCoordinate2D(latitude: north, longitude: est),
            southWest: CLLocationCoordinate2D(latitude: south, longitude: west))
        self.viewPorts.append(newViewPort)
        overlayController.content = self.viewPorts
        let overlay: ViewPortOverlay = ViewPortOverlay(coordinates: newViewPort.boundary, count: newViewPort.boundary.count)
        overlay.name = newViewPort.name
        self.mapView.addOverlay(overlay)
        self.overlayTable.reloadData()
        updateMenu()
    }

    func updateMenu()
    {
        if let appDel = NSApplication.shared.delegate as? AppDelegate
        {
            appDel.updateMenuItems(removePin: annotationsTableView.numberOfSelectedRows > 0,
                                   removeAllPins: annotations.count > 0,
                                   addOverlay: true,
                                   removeOverlay: self.overlayTable.numberOfSelectedRows > 0,
                                   removeAllOverlay: viewPorts.count > 0)
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        updateMenu()
    }

    @IBAction func overlayDoubleTap(_ sender: Any)
    {
        let selectedIndex = overlayTable.selectedRow
        self.mapView.setVisibleMapRect(viewPorts[selectedIndex].overlayBoundingMapRect, edgePadding: NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)

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

    @IBAction func addOverlayItem(_ sender: Any)
    {
        self.performSegue(withIdentifier: "addOverlaySegue", sender: self)
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

    @IBAction func removeSelectedOverlay(_ sender: Any)
    {
        var toRemove:[ViewPort] = []
        for index in overlayTable.selectedRowIndexes
        {
            toRemove.append(viewPorts[index])
        }
        let toKeep = viewPorts.compactMap { vp -> (ViewPort?) in
            if let _ = toRemove.firstIndex(of: vp)
            {
                return nil
            }
            return vp
        }

        viewPorts = toKeep
        overlayController.content = viewPorts
        overlayTable.reloadData()
        
        let overleysToRemove = self.mapView.overlays.compactMap { overlay -> MKOverlay? in
            let contains: Bool = toRemove.contains(where: { vp -> Bool in
                return vp.name == (overlay as? ViewPortOverlay)?.name
            })
            if contains == true
            {
                return overlay
            }
            return nil
        }
        self.mapView.removeOverlays(overleysToRemove)
        updateMenu()
    }

    @IBAction func removeAllOverlay(_ sender: Any)
    {
        viewPorts.removeAll()
        mapView.removeOverlays(mapView.overlays)
        overlayController.content = viewPorts
        overlayTable.reloadData()
        updateMenu()
    }
}

extension ViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolygon
        {
            let polygone = MKPolygonRenderer(overlay: overlay)
            polygone.fillColor = NSColor.magenta.withAlphaComponent(0.4)
            return polygone
        }
        return MKOverlayRenderer()
    }
}
