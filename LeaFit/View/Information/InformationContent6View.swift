//
//  InformationContent6View.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 11/06/25.
//

import SwiftUI

struct InformationContent6View: View {
    var body: some View {
        VStack(spacing: 34) {
            Image("img-information1")
                .resizable()
                .frame(width: 288, height: 228)
            
            Text("Start identifying, treating, and caring for your plants.")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundColor(LeaFitColors.primary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    InformationContent6View()
}
