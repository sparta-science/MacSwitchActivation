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
        assert(NSApp.mainWindow == nil, "loaded before becoming main")
    }
    @IBAction func showMainWindow(_ sender: Any) {
        NSApp.setActivationPolicy(.regular)
        defaults.set(false, forKey: "accessory")

        showWindow(sender)

        let running = NSRunningApplication.current
        assert(!running.isHidden)
        assert(running.isActive)
        // TODO: fails only in UI tests:
//        assert(running.ownsMenuBar)
        let mainMenu = NSApp.mainMenu
        assert(mainMenu != nil)
        assert(mainMenu!.isTornOff == false)
        assert(mainMenu!.menuChangedMessagesEnabled == false)
        assert(window != nil)
        assert(window!.isVisible)
        DispatchQueue.main.async {
            assert(NSApp.mainWindow === self.window, "should become main")
            self.makeMenuBarVisible()
        }
    }
    
    func makeMenuBarVisible() {
        NSMenu.setMenuBarVisible(false)
        DispatchQueue.main.async {
            NSMenu.setMenuBarVisible(true)
        }
    }
    
    override func showWindow(_ sender: Any?) {
        if !defaults.bool(forKey: "accessory") {
            super.showWindow(sender)
        }
        print(#function)
    }
}

extension WindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        print(#function)
        NSApp.setActivationPolicy(.accessory)
        defaults.set(true, forKey: "accessory")
    }
    func windowDidBecomeMain(_ notification: Notification) {
        print(#function)
    }
    func windowDidResignMain(_ notification: Notification) {
        print(#function)
    }
    func windowDidBecomeKey(_ notification: Notification) {
        print(#function)
    }
    func windowDidResignKey(_ notification: Notification) {
        print(#function)
    }
}
