//
//  Color.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import Foundation
import SwiftUI

public extension Color {
    
    static let appBackgroundColor = Color(hex: "E1EEDF")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >> 8) & 0xFF) / 255
        b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
