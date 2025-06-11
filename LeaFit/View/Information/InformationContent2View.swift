//
//  InformationContent2View.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 11/06/25.
//

import SwiftUI

struct InformationContent2View: View {
    var body: some View {
        VStack {
            Image("img-information2")
                .resizable()
                .frame(width: 129, height: 160)
                .padding(.bottom, 34)
            
            Text("Just point your camera at a leaf.")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundColor(LeaFitColors.primary)
                .padding(.bottom, 2)
            
            Text("LeaFit will spot signs of disease, discoloration, and stress all in seconds.")
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(LeaFitColors.textGrey)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    InformationContent2View()
}
