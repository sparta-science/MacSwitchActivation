//
//  WindowController.swift
//  SwitchActivation
//
//  Created by Sparta Science on 6/19/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    let defaults = UserDefaults.standard
    override func windowDidLoad() {
        super.windowDidLoad()
        print(#function)
    }
    @IBAction func showMainWindow(_ sender: Any) {
        showWindow(sender)
        NSApp.setActivationPolicy(.regular)
        defaults.set(false, forKey: "accessory")
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        print(#function)
    }
}

extension WindowController: NSWindowDelegate {
    public func windowWillClose(_ notification: Notification) {
        print(#function)
        NSApp.setActivationPolicy(.accessory)
        defaults.set(true, forKey: "accessory")
    }
    public func windowDidBecomeKey(_ notification: Notification) {
        print(#function)
    }
}
