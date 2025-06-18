//
//  JournalView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 17/06/25.
//

import SwiftUI

struct JournalEntry: Identifiable {
    let id = UUID()
    
    let image: String
    let diseases: [String: Double] // Disease name and confidence percentage
    let date: Date
    
    //buat cari disease persentase tertinggi and ditampilin di card
    var primaryDisease: String {
        diseases.max(by: { $0.value < $1.value })?.key ?? "Unknown"
    }
    
    var diseaseDisplayText: String {
        let sortedDiseases = diseases.sorted(by: { $0.value > $1.value })
        guard let primary = sortedDiseases.first else { return "Unknown" }

        let othersCount = sortedDiseases.count - 1

        //kalo other cuma 1 jadi other, kalo lebih dari 1 jadi others
        if othersCount <= 0 {
            return primary.key
        } else if othersCount == 1 {
            return "\(primary.key) (1 other)"
        } else {
            return "\(primary.key) (\(othersCount) others)"
        }
    }
}

struct JournalView: View {
        
    let pot: Pot
    // Dummy data
    @State private var journalEntries: [JournalEntry] = [
        JournalEntry(
            image: "aloe_sample",
            diseases: ["kocak": 0.81],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 11, hour: 15, minute: 30))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["Anthracnose": 0.85, "Leaf Spot": 0.12],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 17, hour: 14, minute: 30))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["sakit jiwa": 0.92],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 16, hour: 10, minute: 15))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["Rust": 0.78, "test1": 0.33, "test2": 0.05],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15, hour: 16, minute: 45))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["Black Spot": 0.89, "tes1": 0.08],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 14, hour: 9, minute: 20))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["Healthy": 0.95],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 13, hour: 11, minute: 10))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["Leaf Curl": 0.67, "test1": 0.25, "test2": 0.06],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 12, hour: 13, minute: 55))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["Rot": 0.81],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 11, hour: 15, minute: 30))!
        )
    ]
    
    //sorting biar ngambil yg terbaru king
    private var sortedEntries: [JournalEntry] {
        journalEntries.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack { // Back to spacing: 16
                    ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, entry in
                        JournalCard(
                            image: entry.image,
                            disease: entry.diseaseDisplayText,
                            date: entry.date,
                            
                            isFirst: index == 0,
                            isLast: index == sortedEntries.count - 1
                        )
                    }
                }
                .padding(.top, 20)
            }
            
            .navigationTitle(pot.namePot)
            .navigationBarTitleDisplayMode(.large)
            .background(LeaFitColors.background)
        }
    }
    
    // Function to add new journal entry (can be called from ResultView)
    func addJournalEntry(image: String, diseases: [String: Double]) {
        let newEntry = JournalEntry(
            image: image,
            diseases: diseases,
            date: Date()
        )
        journalEntries.append(newEntry)
    }
}

#Preview {
    JournalView(pot: Pot(id: UUID(), namePot: "My Aloe Plant", leaves: []))
}
