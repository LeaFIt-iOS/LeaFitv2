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

final class ResultDetailViewModel: ObservableObject {
    @Published var date = Date()
    @Published var notes: String = ""
    
    @Published var pots: [Pot] = []
    @Published var selectedPot: Pot? = nil
    
    func loadPots(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Pot>(sortBy: [SortDescriptor(\.namePot)])
            pots = try context.fetch(descriptor)
            selectedPot = pots.first // Safely unwrap
        } catch {
            print("Failed to fetch pots: \(error)")
        }
    }
}
