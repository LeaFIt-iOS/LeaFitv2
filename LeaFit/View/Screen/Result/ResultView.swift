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
    
    var body: some View {
        switch viewModel.predictionState {
        case .processing:
            ProgressView("Processing...")
                .progressViewStyle(CircularProgressViewStyle(tint: LeaFitColors.primary))
                .foregroundColor(LeaFitColors.primary)
                .navigationBarBackButtonHidden(true)
                .accentColor(LeaFitColors.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LeaFitColors.background)
        case .finished:
            if viewModel.highestScores != [:]{
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
                                        .overlay(
                                            Group {
                                                Image(uiImage: viewModel.uiImage!)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                                .overlay(
                                                    buildMaskImage(mask: viewModel.combinedMaskImage)
                                                        .opacity(0.7))
                                                .overlay(
                                                    DetectionViewRepresentable(
                                                        predictions: $viewModel.predictions)
                                                    .opacity(0))
                                        )
                                }
                            )
                        
                        DisclosureGroup(
                            isExpanded: $showDiagnose,
                            content: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        ForEach(Array(viewModel.highestScores.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, score in
                                            Text("\(String(format: "%.2f", score * 100))%")
                                                .font(.system(size: 48, weight: .bold, design: .default))
                                                .foregroundColor(LeaFitColors.green)
                                            
                                            HStack {
                                                Circle()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(LeaFitColors.green)
                                                
                                                Text(diseaseId)
                                                    .font(.system(size: 17, weight: .semibold, design: .default))
                                                    .foregroundColor(LeaFitColors.primary)
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        Text("This prediction is based solely on the image and may not be accurate. For a definitive diagnosis and further information, please consult an expert or conduct additional research independently.")
                                            .font(.system(size: 14, weight: .regular, design: .default))
                                            .foregroundColor(LeaFitColors.textGrey)
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
                                    
                                    ForEach(Array(viewModel.highestScores.sorted(by: { $0.value > $1.value })), id: \.key) { score in
                                        if let matchedItem = diseases.first(where: { $0.diseaseId == score.key }) {
                                            VStack(alignment: .leading, spacing: 12) {
                                                Text("[\(matchedItem.nameDisease)]")
                                                    .font(.system(size: 14, weight: .bold, design: .default))
                                                    .padding(.top)
                                                
                                                Text(matchedItem.explanation)
                                                    .font(.system(size: 14, weight: .regular, design: .default))
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                                .padding(.top, 4)
                            },
                            label: {
                                Text("About These Diseases")
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
                                    
                                    ForEach(Array(viewModel.highestScores.sorted(by: { $0.value > $1.value })), id: \.key) { score in
                                        if let matchedItem = diseases.first(where: { $0.diseaseId == score.key }) {
                                            VStack(alignment: .leading, spacing: 12) {
                                                Text("[\(matchedItem.nameDisease)]")
                                                    .font(.system(size: 14, weight: .bold, design: .default))
                                                    .padding(.top)
                                                
                                                Text("Prevention : ")
                                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                                
                                                ForEach(matchedItem.prevention, id: \.preventionTitle) { prevention in
                                                    Text(prevention.preventionTitle)
                                                        .font(.system(size: 12, weight: .semibold, design: .default))
                                                    
                                                    Text(prevention.preventionDetail)
                                                        .font(.system(size: 10, weight: .regular, design: .default))
                                                }
                                                
                                                Text("Watering : ")
                                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                                
                                                ForEach(matchedItem.watering, id: \.wateringTips) { watering in
                                                    ForEach(watering.wateringCondition, id: \.condition) { wateringCondition in
                                                        Text("\(wateringCondition.condition) - \(wateringCondition.wateringFrequency) (Frequency) - \(wateringCondition.wateringVolume) (Volume) - \(wateringCondition.wateringNote) (Note)")
                                                            .font(.system(size: 12, weight: .semibold, design: .default))
                                                    }
                                                    
                                                    Text(watering.wateringTips)
                                                        .font(.system(size: 10, weight: .semibold, design: .default))
                                                }
                                                
                                                
                                                Text("Drying : ")
                                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                                
                                                ForEach(matchedItem.drying, id: \.dryingTips) { drying in
                                                    ForEach(drying.dryingCondition, id: \.plantCondition) { dryingCondition in
                                                        Text("\(dryingCondition.plantCondition) - \(dryingCondition.dryingDuration) (Duration) - \(dryingCondition.dryingBestTime) (Best Time) - \(dryingCondition.dryingNote) (Note)")
                                                            .font(.system(size: 12, weight: .semibold, design: .default))
                                                    }
                                                    
                                                    Text(drying.dryingTips)
                                                        .font(.system(size: 10, weight: .semibold, design: .default))
                                                }
                                                
                                                Divider()
                                            }
                                            .padding(.horizontal)
                                        }
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
                                }
                            )
                        Text("Healthy yey")
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
                
            }
            
        }
        
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
