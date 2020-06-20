//
//  AppDelegate.swift
//  SwitchActivation
//
//  Created by Sparta Science on 6/19/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let defaults = UserDefaults.standard

    func applicationDidBecomeActive(_ notification: Notification) {
        print(#function)
    }
    func applicationWillUpdate(_ notification: Notification) {
//        print(#function)
    }
    func applicationWillFinishLaunching(_ notification: Notification) {
        print(#function)
        assert(NSApp.mainMenu != nil)
        if defaults.bool(forKey: "accessory") {
            NSApp.setActivationPolicy(.accessory)
        }
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print(#function)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let defaults = UserDefaults.standard
        if let start = defaults.object(forKey: "startAsAccessory") {
            defaults.set(start, forKey: "accessory")
        }
        print(#function)
    }

}

