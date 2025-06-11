//
//  InformationContent3View.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 11/06/25.
//

import SwiftUI

struct InformationContent3View: View {
    var body: some View {
        VStack {
            Image("img-information3")
                .resizable()
                .frame(width: 129, height: 160)
                .padding(.bottom, 34)
            
            Text("Treatment Suggestions & Info")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundColor(LeaFitColors.primary)
                .padding(.bottom, 2)
            
            Text("After detecting an issue, we’ll show you the disease details and treatment suggestions so you can take the right steps to help your plant recover.")
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(LeaFitColors.textGrey)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    InformationContent3View()
}
