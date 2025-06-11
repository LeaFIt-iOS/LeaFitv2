//
//  InformationContent4View.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 11/06/25.
//

import SwiftUI

struct InformationContent4View: View {
    
    let contents: [ContentItem] = [
        ContentItem(image: "img-information4.1", title2: "Use Bright Lighting", caption: "Take the photo in natural light or a well lit room avoid shadows and glare."),
        ContentItem(image: "img-information4.2", title2: "Show the Leaf Clearly", caption: "Make sure the leaf (especially the diseased part) is fully visible in the frame."),
        ContentItem(image: "img-information4.3", title2: "Keep It Sharp", caption: "Hold your device steady avoid blurry photos.")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 34) {
            ForEach(contents) { item in
                HStack(spacing: 20) {
                    Image(item.image)
                        .resizable()
                        .frame( width: 66, height: 66
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title2)
                            .font(.system(size: 17, weight: .bold, design: .default))
                            .foregroundColor(LeaFitColors.primary)
                        
                        Text(item.caption)
                            .font(.system(size: 15, weight: .medium, design: .default))
                            .foregroundColor(LeaFitColors.textGrey)
                    }
                }
            }
        }
    }
}

#Preview {
    InformationContent4View()
}
