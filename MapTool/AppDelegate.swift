//
//  AppDelegate.swift
//  MapTool
//
//  Created by Pascale Beaulac on 2018-12-27.
//  Copyright © 2018 Prospects. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var removePinITem: NSMenuItem!
    @IBOutlet weak var removeAllPinsItem: NSMenuItem!
    @IBOutlet weak var addOverlayItem: NSMenuItem!
    @IBOutlet weak var removeOverlayItem: NSMenuItem!
    @IBOutlet weak var removeAllOverlayItem: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func actionMenuItemSelected(_ sender: NSMenuItem) {
        print("ViewController:actionMenuItemSelected")
    }

    func updateMenuItems(removePin: Bool, removeAllPins: Bool, addOverlay: Bool, removeOverlay: Bool, removeAllOverlay: Bool)
    {
        removePinITem.isEnabled = removePin
        removeAllPinsItem.isEnabled = removeAllPins
        addOverlayItem.isEnabled = addOverlay
        removeOverlayItem.isEnabled = removeOverlay
        removeAllOverlayItem.isEnabled = removeAllOverlay
    }
}

