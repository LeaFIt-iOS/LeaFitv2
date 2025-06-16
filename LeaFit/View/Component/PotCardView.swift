//
//  PotCardView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 14/06/25.
//

import SwiftUI
import Foundation

struct PotCardView: View {
    
    let pots: Pot
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 155, height: 150)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 100, weight: .bold, design: .default))
                    .foregroundColor(Color(hex:"428D6D"))
            }
            Text(pots.namePot)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex:"428D6D"))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0 , y: 2)
        
    }
}

#Preview {
    PotCardView(pots: Pot(id: UUID(), namePot: "Aloe Pot", leaves: [], plantCategory: nil))
}
