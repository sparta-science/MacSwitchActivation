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
    func applicationDidBecomeActive(_ notification: Notification) {
        print(#function)
    }
    func applicationWillUpdate(_ notification: Notification) {
//        print(#function)
    }
    func applicationWillFinishLaunching(_ notification: Notification) {
        print(#function)
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print(#function)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

