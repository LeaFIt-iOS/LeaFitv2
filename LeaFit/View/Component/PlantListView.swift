//
//  PlantListView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import SwiftUI
import Foundation

struct PlantListView: View {
    
    @State private var selectedCategory: PlantCategory?
    
    let pots: [Pot]
    let title: String
    
    var body: some View {
        ZStack {
            Color.appBackgroundColor.ignoresSafeArea()
            VStack {
                if !pots.isEmpty {
                    List(pots, id: \.self) { plant in
                        Text(plant.namePot)
                    }
                } else {
                        Spacer()
                            .frame(height: 170)
                        Image("EmptyCategoryLogo2")
                        Text("\(title) is empty")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                        Text("Start by adding pictures of your plants!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    
                }
            }
        }
        .navigationTitle(title)
        .scrollContentBackground(.hidden) // hide default list background
        .background(Color.appBackgroundColor.ignoresSafeArea())
    }
    
}
//
//#Preview {
//    PlantListView(plants: ["Monstera", "Palm"], title: "Sample Category")
//}

//#Preview {
//    PlantListView(plants: [], title: "Sample Category")
//}
