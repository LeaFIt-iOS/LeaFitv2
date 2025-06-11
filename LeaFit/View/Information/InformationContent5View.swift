//
//  InformationContent5View.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 11/06/25.
//

import SwiftUI

struct InformationContent5View: View {
    var body: some View {
        VStack {
            Image("img-information5")
                .resizable()
                .frame(width: 109, height: 110)
                .padding(.bottom, 34)
            
            Text("Your data stays safe.")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundColor(LeaFitColors.primary)
                .padding(.bottom, 2)
            
            Text("We don’t store your personal info or photos without permission.")
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(LeaFitColors.textGrey)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    InformationContent5View()
}
