//
//  ImageCarousel.swift
//  BSDLink
//
//  Created by Azalia Amanda on 03/04/25.
//

/** Complete **/

import SwiftUI

struct ImageCarousel: View {
    let images: [Image]
    let mask: UIImage?
    
    @Binding var predictions: [Prediction]
    
    @State private var index: Int = 0
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    var onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onClose() 
                }
            
            TabView(selection: $index) {
                ForEach(images.indices, id: \.self) { i in
//                    Image(uiImage: images[i])
                    if i == 0 {
                        VStack {
                            Text("Original Image")
                                .foregroundColor(.white)
                            images[i]
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(scale)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            scale = max(1.0, lastScale * value)
                                        }
                                        .onEnded { _ in
                                            lastScale = scale
                                        }
                                )
                                .tag(i)
                        }
                    } else {
                        VStack {
                            Text("Disease Detection Image")
                                .foregroundColor(.white)
                            images[i]
                                .resizable()
                                .scaledToFit()
                                .tag(i)
                                .overlay(
                                    buildMaskImage(mask: mask)
                                        .opacity(0.7))
                                .overlay(
                                    DetectionViewRepresentable(
                                        predictions: $predictions)
                                    .opacity(0))
                        }
                        
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            Button("Close") {
                onClose()
            }
            .padding(.trailing)
            .foregroundColor(.white)
        }
    }
}
