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
        if !running {
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
        window.level = .statusBar
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

//struct Settings {
//    let transparencyRadius: Int
//    let centerTransparency: Int
//}

struct SettingsView: View {
    @State
    private var transparencyRadius: Double
    
    @State
    private var centerTransparency: Double
    
    @Environment(\.dismiss)
    private var dismiss
    
    private var onConfirm: (CatSettings) -> Void
    
    init(
        settings: CatSettings,
        onConfirm: @escaping (CatSettings) -> Void
    ) {
        self.transparencyRadius = Double(settings.transparencyRadius)
        self.centerTransparency = Double(settings.centerTransparency)
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Transparency Radius")
            EnterableSlider(
                value: $transparencyRadius,
                range: 0...400)
            Text("Center Transparency")
            EnterableSlider(
                value: $centerTransparency,
                range: 0...100)
            Spacer(minLength: 24)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("OK") {
                    let settings = CatSettings()
                    settings.transparencyRadius = Int32(transparencyRadius)
                    settings.centerTransparency = Int32(centerTransparency)
                    onConfirm(settings)
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
        }.padding(20).frame(minWidth: 400)
    }
}

struct EnterableSlider: View {
    let value: Binding<Double>
    
    let range: ClosedRange<Double>
    
    let formatter: NumberFormatter
    
    init(value: Binding<Double>, range: ClosedRange<Double>) {
        self.value = value
        self.range = range
        formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimum = (range.lowerBound) as NSNumber
        formatter.maximum = (range.upperBound) as NSNumber
    }
    
    var body: some View {
        HStack {
            Slider(value: value, in: range)
            TextField(
                "number",
                value: value,
                formatter: formatter
            ).frame(width: 80)
        }
    }
}
