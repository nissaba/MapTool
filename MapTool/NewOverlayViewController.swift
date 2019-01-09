//
//  NewOverlayViewController.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2018-12-31.
//  Copyright © 2018 Prospects. All rights reserved.
//

import Cocoa

protocol NewOverlayViewControllerDelegate {
    func didAddViewPort(north: Double, est: Double, south: Double, west: Double)
}

class NewOverlayViewController: NSViewController {
    var delegate: NewOverlayViewControllerDelegate?

    @IBOutlet var westTxtField: NSTextField!
    @IBOutlet var eastTxtField: NSTextField!
    @IBOutlet var southTxtField: NSTextField!
    @IBOutlet var northTxtField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(self)
    }
    @IBAction func addOverlay(_ sender: Any) {
        let north:Double = (northTxtField.doubleValue)
        let east:Double = (eastTxtField.doubleValue)
        let south:Double = (southTxtField.doubleValue)
        let west:Double = (westTxtField.doubleValue)

        self.delegate?.didAddViewPort(north: north, est: east, south: south, west: west)
        self.dismiss(self)
    }

}
