//
//  SettingsView.swift
//  Neko
//
//  Created by MeowCat on 2025/1/5.
//

import Foundation
import SwiftUI

open class SettingsViewModel: ObservableObject {
    private var catSettings: CatSettings
    
    init(_ catSettings: CatSettings) {
        self.catSettings = catSettings
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
}

struct SettingsView: View {
    @StateObject
    private var settings: SettingsViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    private var onConfirm: (CatSettings) -> Void
    
    init(
        settings: CatSettings,
        onConfirm: @escaping (CatSettings) -> Void
    ) {
        self._settings = StateObject(
            wrappedValue: SettingsViewModel(settings))
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Transparency Radius")
            EnterableSlider(
                value: .convert($settings.transparencyRadius),
                range: 0...400)
            Text("Center Transparency")
            EnterableSlider(
                value: .convert($settings.centerTransparency),
                range: 0...100)
            Spacer(minLength: 24)
            HStack {
                Spacer()
                Button("Cancel") {
//                    settings.catSettings.load()
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("OK") {
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
        }.padding(20).frame(minWidth: 400)
    }
}
