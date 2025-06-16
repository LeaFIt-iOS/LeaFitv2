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
    
    private let treatments: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
    ]
    
    var body: some View {
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
                            
                            
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray)
                                .opacity(0.2)
                                .frame(width: 175, height: 175)
                                .onTapGesture {
                                    Task {
                                        await viewModel.runInference()
                                    }
                                }
                                .overlay(
                                    Group{
//                                        if viewModel.processing {
//                                            ProgressView()
//                                        } else {
                                        if let uiImage = viewModel.combinedMaskImage {
                                            Image(uiImage: viewModel.uiImage!)
                                                .resizable()
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
//                                        }
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                        .overlay(
                                        buildMaskImage(mask: viewModel.combinedMaskImage)
                                            .opacity(0.7))
                                    .overlay(
                                        DetectionViewRepresentable(
                                            predictions: $viewModel.predictions)
                                        .opacity(0))
//                                    .frame(maxHeight: 400)
                                    
//                                    Image(uiImage: image.getMaskImage()).resizable().scaledToFit().frame(width: 175, height: 175)
//                                    ForEach(Array(viewModel.maskPredictions.enumerated()), id: \.offset) { index, maskPrediction in
//                                        VStack(alignment: .center) {
//                                            Group {
//                                                if let maskImg = maskPrediction.getMaskImage() {
//                                                    Image(uiImage: maskImg)
//                                                        .resizable()
//                                                        .antialiased(false)
//                                                        .interpolation(.none)
//                                                        .aspectRatio(contentMode: .fit)
//                                                        .background(Color.black)
//                                                        .contextMenu {
//                                                            Button(action: {
//                                                                UIImageWriteToSavedPhotosAlbum(maskImg, nil, nil, nil)
//                                                            }) {
//                                                                Label("Save to camera roll", systemImage: "square.and.arrow.down")
//                                                            }
//                                                        }
//                                                } else {
//                                                    let _ = print("maskImg is nil")
//                                                }
//                                            }
//                                            Divider()
//                                        }.frame(maxWidth: .infinity, alignment: .center)
//                                    }
                                )
                        }
                    )
                
                DisclosureGroup(
                    isExpanded: $showDiagnose,
                    content: {
                        VStack(alignment: .leading, spacing: 4) {
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("70%")
                                    .font(.system(size: 48, weight: .bold, design: .default))
                                    .foregroundColor(LeaFitColors.green)
                                
                                HStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(LeaFitColors.green)
                                    
                                    Text("[Disease Name]")
                                        .font(.system(size: 17, weight: .semibold, design: .default))
                                        .foregroundColor(LeaFitColors.primary)
                                }
                                
                                Text("This prediction is based solely on the image and may not be accurate. For a definitive diagnosis and further information, please consult an expert or conduct additional research independently.")
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(LeaFitColors.textGrey)
                                
                                Divider()
                            }
                            .padding()
                        }
                        .padding(.top, 4)
                    },
                    label: {
                        Text("Diagnosa")
                            .font(.system(size: 24, weight: .semibold, design: .default))
                    }
                )
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                .accentColor(LeaFitColors.primary)
                
                DisclosureGroup(
                    isExpanded: $showDiagnoseExplanation,
                    content: {
                        VStack(alignment: .leading) {
                            Divider()
                            
                            Text("This prediction is based solely on the image and may not be accurate. For a definitive diagnosis and further information, please consult an expert or conduct additional research independently.")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(LeaFitColors.textGrey)
                                .padding()
                        }
                        .padding(.top, 4)
                    },
                    label: {
                        Text("What is [Decease]")
                            .font(.system(size: 24, weight: .semibold, design: .default))
                    }
                )
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                .accentColor(LeaFitColors.primary)
                
                DisclosureGroup(
                    isExpanded: $showTreatmentExplanation,
                    content: {
                        VStack(alignment: .leading) {
                            Divider()
                            
                            ForEach(treatments, id: \.self) { treatment in
                                VStack {
                                    Text(treatment)
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                    
                                    Divider()
                                }
                                .padding(.vertical, 8)
                            }
                            
                        }
                        .padding(.top, 4)
                    },
                    label: {
                        Text("Treatment")
                            .font(.system(size: 24, weight: .semibold, design: .default))
                    }
                )
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                .accentColor(LeaFitColors.primary)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ResultDetailView()) {
                    Text("Next")
                }
            }
        }
        .accentColor(LeaFitColors.primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LeaFitColors.background)
        .onAppear {
            
            viewModel.addImage(image)
        }
//        .onChange(of: viewModel.uiImage) { oldValue, newValue in
//            Task {
//                await viewModel.runInference()
//            }
//        }
    }
    
    
    @ViewBuilder private func buildMaskImage(mask: UIImage?) -> some View {
        if let mask {
            Image(uiImage: mask)
                .resizable()
                .antialiased(false)
                .interpolation(.none)
        }
    }
    
    @ViewBuilder private func buildMasksSheet() -> some View {
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
