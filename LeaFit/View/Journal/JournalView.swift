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
    
    let originalImage: UIImage
    let processedImage: UIImage
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
    
    private var otherDiseasesCount: Int {
        leaf.diagnose.count - 1
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
                    otherDiseasesTotal: otherDiseasesCount,
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
    @State private var selectedEntry: Leaf? = nil
    
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
            if !leaves.isEmpty {
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
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        
                        Text("\(sortedLeaves.count) Pictures")
                            .font(.footnote)
                            .foregroundColor(Color(hex:"428D6D"))
                        Spacer()
                        
                        NavigationLink(destination: CameraView()) {
                            Image(systemName: "camera")
                                .foregroundStyle(Color(hex: "428D6D"))
                        }
                    }
                }
                .background(LeaFitColors.background.ignoresSafeArea())
            } else {
                VStack {
                    Spacer()
                    Image("EmptyCategoryLogo2")
                    Text("\(pot?.namePot ?? "Unknown Pot") is empty")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                    Text("Start taking your pictures here!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    NavigationLink (destination: CameraView()){
                        HStack (spacing: 2){
                            Image(systemName: "camera.fill")
                                .foregroundColor(Color(hex: "428D6D"))
                                .font(.system(size: 18, weight: .semibold, design: .default))
                            Text("Take Picture")
                                .foregroundColor(Color(hex: "428D6D"))
                                .font(.system(size: 17, weight: .semibold, design: .default))
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LeaFitColors.background)
                .ignoresSafeArea()
                
            }
            
        }
        
        .scrollContentBackground(.hidden)
        .onAppear {
            printSelectedPot()
        }
        .sheet(item: $selectedEntry) { entry in
            JournalResultModalView(entry: entry)
        }
    }
    
    // Extracted helper method
    private func handleLeafTap(_ leaf: Leaf) {
            selectedEntry = leaf
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
        print("This is from 🪴: \(pot?.namePot ?? "No pot passed")　\n")
        
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
            print("\n")
        }
    }
}

extension Leaf: Identifiable, Equatable {
    static func == (lhs: Leaf, rhs: Leaf) -> Bool {
        lhs.id == rhs.id
    }
}



#Preview {
    JournalView(pot: Pot(id: UUID(), namePot: "My Aloe Plant", leaves: []))
}
