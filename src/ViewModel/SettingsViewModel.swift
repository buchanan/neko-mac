//
//  SettingsViewModel.swift
//  Neko
//
//  Created by MeowCat on 2025/1/28.
//

import Foundation
import ServiceManagement

enum AutostartErrorKind {
    case register, unregister
}

public let kAutostartKey = "autostart"

class SettingsViewModel: ObservableObject {
    private var catSettings: CatSettings
    
    @Published
    var easterEggClickCount = 0
    
    @Published
    var autoStart: Bool = false {
        didSet {
            autostartError = nil
            UserDefaults.standard.set(autoStart, forKey: kAutostartKey)
            if autoStart {
                do {
                    try SMAppService.mainApp.register()
                } catch let error as NSError {
                    if error.code != kSMErrorAlreadyRegistered {
                        autostartError = .register
                        debugPrint("Cannot register autostart: \(error)")
                    }
                }
            } else {
                do {
                    try SMAppService.mainApp.unregister()
                } catch let error as NSError {
                    if error.code != kSMErrorJobNotFound {
                        autostartError = .unregister
                        debugPrint("Cannot unregister autostart: \(error)")
                    }
                }
            }
        }
    }
    
    @Published
    var autostartError: AutostartErrorKind?
    
    var onLayoutChanged: () -> Void
    
    init(
        _ catSettings: CatSettings,
        onLayoutChanged: @escaping () -> Void
    ) {
        self.catSettings = catSettings
        self.onLayoutChanged = onLayoutChanged
        if UserDefaults.standard.bool(forKey: kAutostartKey) {
            autoStart = true
        }
    }
    
    var transparencyRadius: Int32 {
        get { catSettings.transparencyRadius }
        set {
            objectWillChange.send()
            catSettings.transparencyRadius = newValue
        }
    }
    
    var centerTransparency: Int32 {
        get { catSettings.centerTransparency }
        set {
            objectWillChange.send()
            catSettings.centerTransparency = newValue
        }
    }
    
    var numCats: Int32 {
        get { catSettings.numCats }
        set {
            objectWillChange.send()
            catSettings.numCats = newValue
            onLayoutChanged()
        }
    }
    
    var cursorOffsetX: Int32 {
        get { catSettings.cursorOffsetX }
        set {
            objectWillChange.send()
            catSettings.cursorOffsetX = newValue
        }
    }
    
    var cursorOffsetY: Int32 {
        get { catSettings.cursorOffsetY }
        set {
            objectWillChange.send()
            catSettings.cursorOffsetY = newValue
        }
    }
    
    func finish() -> CatSettings {
        return self.catSettings
    }
}
