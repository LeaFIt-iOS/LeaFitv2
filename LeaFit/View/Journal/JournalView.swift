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
        
    let image: UIImage
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

// Extracted view component
struct LeafCardView: View {
    let leaf: Leaf
    let index: Int
    let totalCount: Int
    let onTap: (Leaf) -> Void
    
    private var image: UIImage? {
        UIImage(data: leaf.processedImage)
    }
    
    private var topDisease: Diagnose? {
        leaf.diagnose.max { $0.confidenceScore < $1.confidenceScore }
    }
    
    private var diseaseDisplay: String {
        if let disease = topDisease {
            return "\(disease.diseaseId.capitalized) (\(disease.confidenceScore)%)"
        } else {
            return "Healthy"
        }
    }
    
    private var isFirst: Bool {
        index == 0
    }
    
    private var isLast: Bool {
        index == totalCount - 1
    }
    
    var body: some View {
        Group {
            if let image = image {
                JournalCard(
                    image: image,
                    disease: diseaseDisplay,
                    date: leaf.dateCreated,
                    isFirst: isFirst,
                    isLast: isLast
                )
                .onTapGesture {
                    onTap(leaf)
                }
            }
        }
    }
}

struct JournalView: View {
    @State private var selectedEntry: JournalEntry? = nil
    @State private var showModality = false
    
    let pot: Pot?

    // Computed property for leaves from the optional pot
    private var leaves: [Leaf] {
        pot?.leaves ?? []
    }

    // Computed property to sort them by date
    private var sortedLeaves: [Leaf] {
        leaves.sorted(by: { $0.dateCreated > $1.dateCreated })
    }
    
    // Helper computed property for enumerated leaves
    private var enumeratedLeaves: [(Int, Leaf)] {
        Array(sortedLeaves.enumerated())
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(enumeratedLeaves, id: \.1.id) { indexAndLeaf in
                        let index = indexAndLeaf.0
                        let leaf = indexAndLeaf.1
                        
                        LeafCardView(
                            leaf: leaf,
                            index: index,
                            totalCount: sortedLeaves.count,
                            onTap: handleLeafTap
                        )
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle(pot?.namePot ?? "")
            .navigationBarTitleDisplayMode(.large)
            .background(LeaFitColors.background)
            .onAppear {
                printSelectedPot()
            }
        }
        .sheet(isPresented: $showModality) {
            if let entry = selectedEntry {
                JournalResultModalView(entry: entry)
            }
        }
    }
    
    // Extracted helper method
    private func handleLeafTap(_ leaf: Leaf) {
        guard let image = UIImage(data: leaf.processedImage) else { return }
        
        let topDisease = getTopDisease(from: leaf.diagnose)
        let diseases = createDiseaseDictionary(from: topDisease)
        
        selectedEntry = JournalEntry(
            image: image,
            diseases: diseases,
            date: leaf.dateCreated
        )
        showModality = true
    }
    
    // Helper method to get top disease
    private func getTopDisease(from diagnoses: [Diagnose]) -> Diagnose? {
        return diagnoses.max { first, second in
            first.confidenceScore < second.confidenceScore
        }
    }
    
    // Helper method to create disease dictionary
    private func createDiseaseDictionary(from disease: Diagnose?) -> [String: Double] {
        guard let disease = disease else { return [:] }
        return [disease.diseaseId: Double(disease.confidenceScore) / 100.0]
    }
    
    func printSelectedPot() {
        print("This is from 🪴: \(pot?.namePot ?? "No pot passed")")
        
        for leaf in pot?.leaves ?? [] {
            print("""
                        📝 Leaf ID: \(leaf.id)
                        🗾 Image: \(leaf.originalImage)
                        🎇 Image Process: \(leaf.processedImage)
                        📅 Date: \(leaf.dateCreated)
                        🪴 Pot: \(leaf.pot?.namePot ?? "No pot")
                        🧾 Notes: \(leaf.leafNote ?? "-")
                        📊 Diagnoses:
                        \(leaf.diagnose.map { "- DiseaseID: \($0.diseaseId), Confidence: \($0.confidenceScore)" }.joined(separator: "\n"))
                        """)
        }
    }
}




#Preview {
    JournalView(pot: Pot(id: UUID(), namePot: "My Aloe Plant", leaves: []))
}
