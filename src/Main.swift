//
//  Main.swift
//  Neko
//
//  Created by MeowCat on 2024/11/24.
//

import Foundation
import SwiftUI

@main
struct Application {
    static func main() {
        UserDefaults.standard.register(defaults: [
            kTransparencyRadius: 200,
            kCenterTransparency: 80,
        ])
        let delegate = AppDelegate()
        NSApplication.shared.delegate = delegate
        NSApplication.shared.run()
    }
    
    static let debugSettingsUI: Bool = {
        String(cString: getenv("NEKO_DEBUG_SETTINGS_UI")).isTrue
    }()
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var settingsWindow: NSWindow?
    
    private var floatingWindow: MyPanel!
    
    private var running = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        floatingWindow = MyPanel(
            contentRect: NSRect(x: 0, y: 0, width: 32, height: 32),
            styleMask: .borderless,
            backing: .buffered,
            defer: false)
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        if !running && !Application.debugSettingsUI {
            running = true
            return
        } else if settingsWindow != nil {
            return
        }
        running = true
        let window = NSWindow()
        window.contentView = NSHostingView(rootView: SettingsView(
            settings: floatingWindow.settings,
            onConfirm: { [weak self] in
                $0.save()
                self?.floatingWindow.settings = $0
            }
        ))
        window.styleMask.insert(.closable)
        window.delegate = self
        window.isReleasedWhenClosed = false
        window.center()
        window.orderFront(nil)
        settingsWindow = window
    }
    
    func applicationShouldHandleReopen(
        _ sender: NSApplication, hasVisibleWindows: Bool
    ) -> Bool {
        return settingsWindow == nil
    }
    
    func windowWillClose(_ notification: Notification) {
        settingsWindow = nil
    }
}

fileprivate extension String {
    var isTrue: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() == "true"
    }
}

//struct Settings {
//    let transparencyRadius: Int
//    let centerTransparency: Int
//}
