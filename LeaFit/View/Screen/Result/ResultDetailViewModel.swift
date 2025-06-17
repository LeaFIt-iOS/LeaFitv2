//
//  ResultDetailViewModel.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 17/06/25.
//

import Foundation
import SwiftData
import AVFoundation
import UIKit
import SwiftUICore

enum Pots: String, CaseIterable, Identifiable {
    case Pot1, Pot2, Pot3
    var id: Self { self }
}

@Observable
final class ResultDetailViewModel {
    var date = Date()
    var notes: String = ""
    var pots: [Pots] = Pots.allCases
    
    var selectedPot: Pots = Pots.Pot1
    
    init() {
        
    }
}
