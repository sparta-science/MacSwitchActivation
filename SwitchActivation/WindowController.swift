//
//  WindowController.swift
//  SwitchActivation
//
//  Created by Sparta Science on 6/19/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        print(#function)
    }
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        print(#function)
        NSApp.setActivationPolicy(.regular)
    }
}

extension NSWindowController: NSWindowDelegate {
    public func windowWillClose(_ notification: Notification) {
        print(#function)
        NSApp.setActivationPolicy(.accessory)
    }
}
