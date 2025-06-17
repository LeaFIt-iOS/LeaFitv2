//
//  PlantListView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import SwiftUI
import Foundation
import SwiftData

struct PlantListView: View {
    
    @Query private var allPots: [Pot]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedCategory: PlantCategory?
    @State private var showAddPopup = false
    @State private var newPotname = ""
    
    let pots: [Pot]
    let title: String
    
    var filteredPots: [Pot] {
        return allPots
    }
    var subtitle: String {
        switch title {
        case "Aloe Vera":
            return "Aloe vera"
        case "Cactus":
            return "Cactaceae"
        case "Jasmine":
            return "Jasminum"
        case "Bonsai":
            return "Various species" //soalnya bonsai gada nama khusus tergantung jenis bonsia apa
        case "Sansevieria":
            return "Sansevieria"
        case "Rose":
            return "Rosa"
        case "Monstera":
            return "Monstera"
        default:
            return "LeaFit!"
        }
    }
    
    let cardColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var isSaveButtonDisabled: Bool {
            let trimmedName = newPotname.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedName.isEmpty {
                return true
            }
            if trimmedName.count > 24 {
                return true
            }
            if filteredPots.contains(where: { $0.namePot.lowercased() == trimmedName.lowercased() }) {
                return true
            }
            
            return false
        }
    
    var body: some View {
        ZStack {
            Color.appBackgroundColor.ignoresSafeArea()
            VStack {
                HStack {
                    VStack (alignment: .leading, spacing: 4){
                        Text(title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(hex: "428D6D"))
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                if !filteredPots.isEmpty {
                    //                        List(pots, id: \.self) { plant in
                    //                          Text(plant.namePot)
                    
                    ScrollView{
                        LazyVGrid(columns: cardColumns, spacing: 16) {
                                ForEach(filteredPots, id: \.id) { pot in
                                    NavigationLink(destination: DetailPotView(pot: pot)) {
                                        PotCardView(pots: pot)
                                    }
//                                    .buttonStyle(PlainButtonStyle())
                                }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                } else {
                    Spacer().frame(height: 170)
                    Image("EmptyCategoryLogo2")
                    Text("\(title) is empty")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                    Text("Start by adding pictures of your plants!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        Button (action: {
                            showAddPopup = true
                        } ) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color(hex: "428D6D"))
                                .padding(.trailing, -4)
                                .padding(.top, 2)
                                .font(.system(size: 18, weight: .semibold, design: .default))
                            Text("Add Pots")
                                .foregroundColor(Color(hex: "428D6D"))
                                .padding(.top, 2)
                                .font(.system(size: 17, weight: .semibold, design: .default))
                            
                        }
                        
                    }
                    
                    Spacer()
                }
                
                if !filteredPots.isEmpty {
                    Button (action: {
                        showAddPopup = true
                    } ) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color(hex: "428D6D"))
                                .font(.system(size: 18, weight: .semibold, design: .default))
                            Text("Add New Pot")
                                .foregroundColor(Color(hex: "428D6D"))
                                .font(.system(size: 17, weight: .semibold, design: .default))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0 , y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
            }
            
            
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackgroundColor.ignoresSafeArea())
//        .onAppear() {
//            fetchAllPots()
//        }
        .alert("New Pots", isPresented: $showAddPopup) {
            TextField("Type your new pot name", text: $newPotname)
                .foregroundColor(.primary)
            Button("Cancel", role: .cancel) {
                newPotname = ""
            }
            .foregroundColor(Color(hex: "428D6D"))
            Button("Save") {
                savePot()
                
            }
            .disabled(isSaveButtonDisabled)
            .foregroundColor(Color(hex: "428D6D"))
        }
     

    }
    
    private func fetchAllPots() {
        let fetchDescriptor = FetchDescriptor<Pot>()
        
        do {
            let pots = try modelContext.fetch(fetchDescriptor)
            print("=== All Pots ===")
            for pot in pots {
                print("• \(pot.namePot)")
            }
        } catch {
            print("Error fetching pots: \(error)")
        }
    }
    
    private func savePot() {
        
        guard !newPotname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            newPotname = ""
            return
        }
        
        let newPot = Pot(
            namePot: newPotname.trimmingCharacters(in: .whitespacesAndNewlines),
            leaves: []
        )
        
        modelContext.insert(newPot)
        
        do {
            try modelContext.save()
            print( "Saved new pot: \(newPot.namePot)")
            fetchAllPots()
        } catch {
            print("Error saving pot: \(error)")
        }
        
        newPotname = ""
    }
    
}

#Preview {
    NavigationStack{
        PlantListView(pots: [], title: "Aloe Vera")
            .modelContainer(for: [Pot.self, PlantCategory.self, Leaf.self, Diagnose.self], inMemory: true)
    }
}
