//
//  ResultDetailView.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 14/06/25.
//

import SwiftUI
import SwiftData

struct ResultDetailView: View {
    private var originalImage: UIImage
    private var resultImage: UIImage
    private var diagnoses: [Diagnose]
    
    init(originalImage: UIImage, resultImage: UIImage, diagnoses: [Diagnose]) {
        self.originalImage = originalImage
        self.resultImage = resultImage
        self.diagnoses = diagnoses
    }
    
    @StateObject private var viewModel: ResultDetailViewModel = ResultDetailViewModel()
    @State private var navigateToSuccess = false
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    TabView {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray)
                            .opacity(0.2)
                            .frame(height: 393)
                            .overlay(
                                Image(uiImage: originalImage).resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 393)
                            )
                        
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray)
                            .opacity(0.2)
                            .frame(height: 393)
                            .overlay(
                                Image(uiImage: resultImage).resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 393)
                            )
                    }
                    .frame(height: 393)
                    .tabViewStyle(.page)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(height: 170)
                        .overlay(
                            VStack(alignment: .leading) {
                                DatePicker(
                                    "Time",
                                    selection: $viewModel.date,
                                    displayedComponents: [.date]
                                )
//                                
                                Divider()
                                
                                List {
                                    Picker(selection: $viewModel.selectedPot) {
                                        ForEach(viewModel.pots, id: \.self) { pot in
                                            Text(pot.namePot).tag(Optional(pot))
                                        }
                                    } label: {
                                        Text("Pot")
                                    }
                                    .listRowInsets(EdgeInsets())
                                }
                                .listStyle(PlainListStyle())
                                
                                HStack {
                                    Text("Notes")
                                    
                                    TextField(text: $viewModel.notes) {
                                        Text("Add Notes")
                                    }
                                    .multilineTextAlignment(.trailing)
                                }
                            }
                                .padding()
                        )
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePlant()
                    }
                }
            }
            .accentColor(LeaFitColors.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LeaFitColors.background)
            .onAppear {
                viewModel.loadPots(context: context)
            }
            
            .navigationDestination(isPresented: $navigateToSuccess){
                JournalView(pot: viewModel.selectedPot)
            }
        }
    }
    
    func savePlant() {
        // 1. Convert UIImage to Data
        guard let originalImageData = originalImage.jpegData(compressionQuality: 0.8),
              let resultImageData = resultImage.jpegData(compressionQuality: 0.8) else {
            print("❌ Failed to convert images")
            return
        }
        
        // 2. Create Leaf object
        let newLeaf = Leaf(
            originalImage: originalImageData,
            processedImage: resultImageData,
            leafNote: viewModel.notes,
            dateCreated: viewModel.date,
            diagnose: [], // fill this below
            pot: viewModel.selectedPot
        )
        
        // 3. Create Diagnose objects with relationship to newLeaf
        let newDiagnoses = diagnoses.map { passedDiagnose in
            Diagnose(
                confidenceScore: passedDiagnose.confidenceScore,
                diseaseId: passedDiagnose.diseaseId,
                leaf: newLeaf
            )
        }
        
        // 4. Assign diagnoses to leaf
        newLeaf.diagnose = newDiagnoses
        
        // 5. Add to context and save
        context.insert(newLeaf)
        
        do {
            try context.save()
            print("✅ Leaf & Diagnoses saved")
            
            // 🪵 Fetch and print all saved leaves
            let descriptor = FetchDescriptor<Leaf>(sortBy: [SortDescriptor(\.dateCreated, order: .reverse)])
            let allLeaves = try context.fetch(descriptor)
            
            print("📦 Total leaves saved: \(allLeaves.count)")
            for leaf in allLeaves {
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
            
            navigateToSuccess.toggle()
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
}
