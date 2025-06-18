//
//  JournalView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 17/06/25.
//

import SwiftUI
import SwiftData

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
    
    @State private var selectedEntry: JournalEntry? = nil
    @State private var showModality = false
    
    @Environment(\.modelContext) private var modelContext
    
    let pot: Pot?
    // Dummy data
    @State private var journalEntries: [JournalEntry] = [
        JournalEntry(
            image: "aloe_sample",
            diseases: ["sunburn": 0.81],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 11, hour: 15, minute: 30))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["anthracnose": 0.85, "rust": 0.12],
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 17, hour: 14, minute: 30))!
        ),
        JournalEntry(
            image: "aloe_sample",
            diseases: ["rot": 0.92],
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
                LazyVStack {
                    ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, entry in
                        JournalCard(
                            image: entry.image,
                            disease: entry.diseaseDisplayText,
                            date: entry.date,
                            isFirst: index == 0,
                            isLast: index == sortedEntries.count - 1
                        )
                        .onTapGesture {
                            selectedEntry = entry
                            showModality = true
                        }
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle(pot?.namePot ?? "")
            .navigationBarTitleDisplayMode(.large)
            .background(LeaFitColors.background)
        }
        .sheet(isPresented: $showModality) {
            if let entry = selectedEntry {
                JournalResultModalView(entry: entry)
            }
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

// New modal view that recreates the ResultView experience
struct JournalResultModalView: View {
    let entry: JournalEntry
    @Environment(\.dismiss) private var dismiss
    @State private var isFullScreen = false
    @State private var showDiagnose = true
    @State private var showDiagnoseExplanation = false
    @State private var showTreatmentExplanation = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    // Image section similar to ResultView
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LeaFitColors.light)
                        .frame(height: 224)
                        .overlay(
                            HStack(spacing: 16) {
                                // Original image
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .opacity(0.2)
                                    .frame(width: 175, height: 175)
                                    .overlay(
                                        Image(entry.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 175, height: 175)
                                    )
                                    .onTapGesture {
                                        isFullScreen = true
                                    }
                                
                                // Processed image (using same dummy image)
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .opacity(0.2)
                                    .frame(width: 175, height: 175)
                                    .overlay(
                                        Image(entry.image)
                                            .resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    )
                                    .onTapGesture {
                                        isFullScreen = true
                                    }
                            }
                        )
                    
                    // Diagnosis section
                    DisclosureGroup(
                        isExpanded: $showDiagnose,
                        content: {
                            VStack(alignment: .leading, spacing: 4) {
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(Array(entry.diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, score in
                                        Text("\(String(format: "%.2f", score * 100))%")
                                            .font(.system(size: 48, weight: .bold, design: .default))
                                            .foregroundColor(diseaseId == "Healthy" ? LeaFitColors.green : .orange)
                                        
                                        HStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(diseaseId == "Healthy" ? LeaFitColors.green : .orange)
                                            
                                            Text(diseaseId)
                                                .font(.system(size: 17, weight: .semibold, design: .default))
                                                .foregroundColor(LeaFitColors.primary)
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Text("This prediction is based solely on the image and may not be accurate. For a definitive diagnosis and further information, please consult an expert or conduct additional research independently.")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(LeaFitColors.textGrey)
                                }
                                .padding()
                            }
                            .padding(.top, 4)
                        },
                        label: {
                            Text("Diagnosis")
                                .font(.system(size: 24, weight: .semibold, design: .default))
                        }
                    )
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                    .accentColor(LeaFitColors.primary)
                    
                    // About These Diseases section
                    DisclosureGroup(
                        isExpanded: $showDiagnoseExplanation,
                        content: {
                            VStack(alignment: .leading) {
                                Divider()
                                
                                ForEach(Array(entry.diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, _ in
                                    if let matchedItem = diseases.first(where: { $0.diseaseId == diseaseId }) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text("[\(matchedItem.nameDisease)]")
                                                .font(.system(size: 14, weight: .bold, design: .default))
                                                .padding(.top)
                                            
                                            Text(matchedItem.explanation)
                                                .font(.system(size: 14, weight: .regular, design: .default))
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top, 4)
                        },
                        label: {
                            Text("About These Diseases")
                                .font(.system(size: 24, weight: .semibold, design: .default))
                        }
                    )
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                    .accentColor(LeaFitColors.primary)
                    
                    // Treatment section (if diseases are not "Healthy")
                    if !entry.diseases.keys.contains("Healthy") {
                        DisclosureGroup(
                            isExpanded: $showTreatmentExplanation,
                            content: {
                                VStack(alignment: .leading) {
                                    Divider()
                                    
                                    ForEach(Array(entry.diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, _ in
                                        if let matchedItem = diseases.first(where: { $0.diseaseId == diseaseId }) {
                                            VStack(alignment: .leading, spacing: 12) {
                                                Text("[\(matchedItem.nameDisease)]")
                                                    .font(.system(size: 14, weight: .bold, design: .default))
                                                    .padding(.top)
                                                
                                                Text("Prevention : ")
                                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                                
                                                ForEach(matchedItem.prevention, id: \.preventionTitle) { prevention in
                                                    Text(prevention.preventionTitle)
                                                        .font(.system(size: 12, weight: .semibold, design: .default))
                                                    
                                                    Text(prevention.preventionDetail)
                                                        .font(.system(size: 10, weight: .regular, design: .default))
                                                }
                                                
                                                Text("Watering : ")
                                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                                
                                                ForEach(matchedItem.watering, id: \.wateringTips) { watering in
                                                    ForEach(watering.wateringCondition, id: \.condition) { wateringCondition in
                                                        Text("\(wateringCondition.condition) - \(wateringCondition.wateringFrequency) (Frequency) - \(wateringCondition.wateringVolume) (Volume) - \(wateringCondition.wateringNote) (Note)")
                                                            .font(.system(size: 12, weight: .semibold, design: .default))
                                                    }
                                                    
                                                    Text(watering.wateringTips)
                                                        .font(.system(size: 10, weight: .semibold, design: .default))
                                                }
                                                
                                                Text("Drying : ")
                                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                                
                                                ForEach(matchedItem.drying, id: \.dryingTips) { drying in
                                                    ForEach(drying.dryingCondition, id: \.plantCondition) { dryingCondition in
                                                        Text("\(dryingCondition.plantCondition) - \(dryingCondition.dryingDuration) (Duration) - \(dryingCondition.dryingBestTime) (Best Time) - \(dryingCondition.dryingNote) (Note)")
                                                            .font(.system(size: 12, weight: .semibold, design: .default))
                                                    }
                                                    
                                                    Text(drying.dryingTips)
                                                        .font(.system(size: 10, weight: .semibold, design: .default))
                                                }
                                                
                                                Divider()
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                                .padding(.top, 4)
                            },
                            label: {
                                Text("Treatment")
                                    .font(.system(size: 24, weight: .semibold, design: .default))
                            }
                        )
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                        .accentColor(LeaFitColors.primary)
                    }
                }
                .padding()
            }
            .navigationTitle("Diagnosis Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .background(LeaFitColors.background)
        }
    }
}

// Diagnosis section component
struct JournalDiagnosisSection: View {
    let diseases: [String: Double]
    @State private var showDiagnose = true
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $showDiagnose,
            content: {
                VStack(alignment: .leading, spacing: 4) {
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, score in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(String(format: "%.2f", score * 100))%")
                                    .font(.system(size: 48, weight: .bold, design: .default))
                                    .foregroundColor(diseaseId == "Healthy" ? LeaFitColors.green : .orange)
                                
                                HStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(diseaseId == "Healthy" ? LeaFitColors.green : .orange)
                                    
                                    Text(diseaseId)
                                        .font(.system(size: 17, weight: .semibold, design: .default))
                                        .foregroundColor(LeaFitColors.primary)
                                }
                            }
                        }
                        
                        Divider()
                        
                        Text("This prediction is based solely on the image and may not be accurate. For a definitive diagnosis and further information, please consult an expert or conduct additional research independently.")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(LeaFitColors.textGrey)
                    }
                    .padding()
                }
                .padding(.top, 4)
            },
            label: {
                Text("Diagnose")
                    .font(.system(size: 24, weight: .semibold, design: .default))
            }
        )
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
        .accentColor(LeaFitColors.primary)
    }
}


#Preview {
    JournalView(pot: Pot(id: UUID(), namePot: "My Aloe Plant", leaves: []))
}
