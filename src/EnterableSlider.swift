//
//  EnterableSlider.swift
//  Neko
//
//  Created by MeowCat on 2025/1/5.
//

import Foundation
import SwiftUI


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
