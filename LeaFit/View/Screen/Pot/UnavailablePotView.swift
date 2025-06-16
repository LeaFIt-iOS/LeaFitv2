//
//  UnavailablePotView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 14/06/25.
//

import SwiftUI
import Foundation

struct UnavailablePotView: View {
    
    @State private var selectedCategory: PlantCategory?
    let pots: [Pot]
    let title: String
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
    
    var body: some View {
        ZStack {
            Color.appBackgroundColor.ignoresSafeArea()
            VStack() {
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
                
                
                Spacer()
                    .frame(height: 170)
                
                Image("img-growingplantt")
                    .resizable()
                    .frame(width: 137, height: 123)
                    Text("Something's growing here!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                    Text("This feature isn't ready yet,")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("but it's sprouting behind the scenes!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
            
//                .padding()
                
                    Spacer()
                    
                
            }
        }
        
        
    }
}

#Preview {
    UnavailablePotView(pots: [], title: "Cactus")
}
