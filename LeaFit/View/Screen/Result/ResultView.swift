//
//  ResultView.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 14/06/25.
//

import SwiftUI

struct ResultView: View {
    var image: UIImage
    var originalImage: UIImage
    
    @State var showDiagnose = true
    @State var showDiagnoseExplanation = false
    @State var showTreatmentExplanation = false
    @StateObject var viewModel: ContentViewModel
    
    @State private var isFullScreen: Bool = false
    
    var body: some View {
        switch viewModel.predictionState {
        case .processing:
            Progress()
        case .finished:
            if viewModel.highestScores != [:]{
                ScrollView(showsIndicators: false) {
                    SickPlantSection(image: image, originalImage: originalImage, viewModel: viewModel, isFullScreen: $isFullScreen)
                }
                
                .fullScreenCover(isPresented: $isFullScreen) {
                    ImageCarousel(images: [
                        Image(uiImage: originalImage),
                        Image(uiImage: viewModel.uiImage!)],
                                  mask: viewModel.combinedMaskImage,
                                  predictions: $viewModel.predictions) {
                        isFullScreen = false
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ResultDetailView(originalImage: originalImage, resultImage: viewModel.uiImage!)) {
                            Text("Next")
                        }
                    }
                }
                .accentColor(LeaFitColors.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LeaFitColors.background)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LeaFitColors.light)
                            .frame(height: 224)
                            .overlay(
                                HStack(spacing: 16) {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray)
                                        .opacity(0.2)
                                        .frame(width: 175, height: 175)
                                        .overlay(Image(uiImage: originalImage).resizable().scaledToFit().frame(width: 175, height: 175))
                                    //                                        .onTapGesture {
                                    //                                            isFullScreen = true
                                    //                                        }
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray)
                                        .opacity(0.2)
                                        .frame(width: 175, height: 175)
                                        .overlay(
                                            Group{
                                                if let a = viewModel.uiImage {
                                                    Image(uiImage: a)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                } else {
                                                    Text("Nothing to show")
                                                }
                                            }
                                        )
                                    //                                        .onTapGesture {
                                    //                                            isFullScreen = true
                                    //                                        }
                                }
                            )
                        Text("Healthy yey")
                    }
                }
                //                .navigationBarBackButtonHidden(true)
                //                .toolbar {
                //                    ToolbarItem(placement: .navigationBarTrailing) {
                //                        NavigationLink(destination: ResultDetailView(originalImage: originalImage, resultImage: viewModel.uiImage!)) {
                //                            Text("Next")
                //                        }
                //                    }
                //                }
                //                .accentColor(LeaFitColors.primary)
                //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                .background(LeaFitColors.background)
                //                .fullScreenCover(isPresented: $isFullScreen) {
                //                    ImageCarousel(images: [Image(uiImage: originalImage), Image(UIImage: viewModel.uiImage!)]) {
                //                        isFullScreen = false
                //                    }
                //                }
            }
                
            
        }
        
    }
    
    
    @ViewBuilder func buildMaskImage(mask: UIImage?) -> some View {
        if let mask {
            Image(uiImage: mask)
                .resizable()
                .antialiased(false)
                .interpolation(.none)
        }
    }
    
    @ViewBuilder func buildMasksSheet() -> some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 8) {
                ForEach(Array(viewModel.maskPredictions.enumerated()), id: \.offset) { index, maskPrediction in
                    VStack(alignment: .center) {
                        Group {
                            if let maskImg = maskPrediction.getMaskImage() {
                                Image(uiImage: maskImg)
                                    .resizable()
                                    .antialiased(false)
                                    .interpolation(.none)
                                    .aspectRatio(contentMode: .fit)
                                    .background(Color.black)
                                    .contextMenu {
                                        Button(action: {
                                            UIImageWriteToSavedPhotosAlbum(maskImg, nil, nil, nil)
                                        }) {
                                            Label("Save to camera roll", systemImage: "square.and.arrow.down")
                                        }
                                    }
                            } else {
                                let _ = print("maskImg is nil")
                            }
                        }
                        Divider()
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

struct Progress: View {
    var body: some View {
        ProgressView("Processing...")
            .progressViewStyle(CircularProgressViewStyle(tint: LeaFitColors.primary))
            .foregroundColor(LeaFitColors.primary)
            .navigationBarBackButtonHidden(true)
            .accentColor(LeaFitColors.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LeaFitColors.background)
    }
}
