//
//  ResultDetailView.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 14/06/25.
//

import SwiftUI
import SwiftData

struct ResultDetailView: View {
    private var namePot: String
    private var originalImage: UIImage
    private var resultImage: UIImage
    private var diagnoses: [Diagnose]
    private var maskImage: UIImage? = nil
    
    init(namePot: String, originalImage: UIImage, resultImage: UIImage, diagnoses: [Diagnose], maskImage: UIImage) {
        self.namePot = namePot
        self.originalImage = originalImage
        self.resultImage = resultImage
        self.diagnoses = diagnoses
        self.maskImage = maskImage
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
                                Group{
                                    Image(uiImage: resultImage).resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 393)
                                        .overlay{
                                            Image(uiImage: maskImage ?? UIImage())
                                                .resizable()
                                                .antialiased(false)
                                                .interpolation(.none)
                                                .opacity(0.7)
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity, maxHeight: 393)
                                        }
                                }
                            )
                    }
                    .frame(height: 393)
                    .tabViewStyle(.page)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(height: 120)
                        .overlay(
                            VStack(alignment: .leading) {
                                List {
                                    Picker(selection: $viewModel.selectedPot) {
                                        ForEach(viewModel.pots, id: \.self) { pot in
                                            Text(pot.namePot).tag(Optional(pot))
                                        }
                                    } label: {
                                        Text("Pot")
                                    }
                                    .listRowInsets(EdgeInsets())
                                    .disabled(namePot != "" ? true : false)
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
                viewModel.loadPots(namePot: namePot, context: context)
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
            maskImage: maskImage!.pngData()!,
            leafNote: viewModel.notes,
            dateCreated: Date(),
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
