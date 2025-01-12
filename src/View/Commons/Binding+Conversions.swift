//
//  Binding+Conversions.swift
//  Neko
//
//  Created by MeowCat on 2025/1/5.
//

import Foundation
import SwiftUI


public extension Binding {
    static func convert<
        TInt: BinaryInteger & Sendable,
        TFloat: BinaryFloatingPoint
    >(_ intBinding: Binding<TInt>) -> Binding<TFloat> {
        Binding<TFloat> (
            get: { TFloat(intBinding.wrappedValue) },
            set: { intBinding.wrappedValue = TInt($0.rounded()) }
        )
    }

    static func convert<
        TFloat: BinaryFloatingPoint & Sendable,
        TInt: BinaryInteger
    >(
        _ floatBinding: Binding<TFloat>
    ) -> Binding<TInt> {
        Binding<TInt> (
            get: { TInt(floatBinding.wrappedValue) },
            set: { floatBinding.wrappedValue = TFloat($0) }
        )
    }
}
