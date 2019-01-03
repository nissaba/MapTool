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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(self)
    }

}
