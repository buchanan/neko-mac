//
//  Main.swift
//  Neko
//
//  Created by MeowCat on 2024/11/24.
//

import Foundation
import SwiftUI

public let kFirstLaunchVersionKey = "first_launch_version"

public let kVersionInt = 1

@main
struct Application {
    static func main() {
        UserDefaults.standard.register(defaults: [
            kNumCats: 2,
            kTransparencyRadius: 200,
            kCenterTransparency: 80,
            kFirstLaunchVersionKey: 0,
        ])
        let delegate = AppDelegate()
        NSApplication.shared.delegate = delegate
        NSApplication.shared.run()
    }
    
    static let debugSettingsUI: Bool = {
        let v = getenv("NEKO_DEBUG_SETTINGS_UI")
        return v.map { String(cString: $0) }.isTrue
    }()
}

@MainActor
private class CatHouse {
    public let settings: CatSettings
    
    private var panels: [CatPanel] = []
    
    init(settings: CatSettings) {
        self.settings = settings
        let numCats = Int(settings.numCats)
        if numCats <= 0 { return; }
        let offsets: [(CGFloat, CGFloat)] = numCats == 1 ?
            [(0, 0)] : generateCirclePoints(
                radius: 32,
                startingAngle: CGFloat.pi / 3,
                numberOfPoints: numCats)
        panels = offsets.map { offset in
            return CatPanel(
                contentRect: NSRect(x: 0, y: 0, width: 32, height: 32),
                styleMask: .borderless,
                backing: .buffered,
                defer: false,
                offsetX: offset.0,
                offsetY: offset.1)
        }
    }
    
    consuming func close() {
        for panel in panels {
            panel.close()
        }
    }
}

@MainActor
private class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var settingsWindow: NSWindow?
    
    private var house: CatHouse!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let settings = CatSettings()
        settings.load()
        house = CatHouse(settings: settings)
        if Application.debugSettingsUI {
            UserDefaults.standard.set(
                0, forKey: kFirstLaunchVersionKey)
            showSettings()
        } else if UserDefaults.standard.integer(
            forKey: kFirstLaunchVersionKey
        ) < kVersionInt {
            UserDefaults.standard.set(
                kVersionInt, forKey: kFirstLaunchVersionKey)
            showSettings()
        }
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        if settingsWindow != nil {
            return
        }
        showSettings()
    }
    
    private func showSettings() {
        let window = NSWindow()
        window.contentView = NSHostingView(rootView: SettingsView(
            settings: house.settings
        ) { [weak self] in
                guard let self else { return }
                house.close()
                house = CatHouse(settings: house.settings)
            })
        window.title = "🐱 Settings"
        window.styleMask.insert(.closable)
        window.delegate = self
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(self)
        window.orderFrontRegardless()
        settingsWindow = window
    }
    
    func applicationShouldHandleReopen(
        _ sender: NSApplication, hasVisibleWindows: Bool
    ) -> Bool {
        true
    }
    
    func windowWillClose(_ notification: Notification) {
        settingsWindow = nil
    }
}

fileprivate extension String? {
    var isTrue: Bool {
        self?.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() == "true"
    }
}

fileprivate func generateCirclePoints(
    radius: CGFloat,
    startingAngle: CGFloat,
    numberOfPoints: Int
) -> [(CGFloat, CGFloat)] {
    let angleIncrement = (2 * CGFloat.pi) / CGFloat(numberOfPoints)
    return (0..<numberOfPoints).map { i in
        let angle = startingAngle - CGFloat(i) * angleIncrement
        let x = radius * cos(angle)
        let y = radius * sin(angle)
        return (x, y)
    }
}
