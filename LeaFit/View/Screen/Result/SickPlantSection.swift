//
//  HealthyPlantSection.swift
//  LeaFit
//
//  Created by Azalia Amanda on 18/06/25.
//

import SwiftUI

struct SickPlantSection: View {
    var image: UIImage
    var originalImage: UIImage
    
    @State var showDiagnose = true
    @State var showDiagnoseExplanation = false
    @State var showTreatmentExplanation = false
    @StateObject var viewModel: ContentViewModel
    
    @Binding var isFullScreen: Bool
    
    private func displayColor(_ disease: String) -> Color {
        let disease = disease.lowercased()
        switch true {
        case disease.contains("anthracnose"):
            return LeaFitColors.anthracnose
        case disease.contains("rot"):
            return LeaFitColors.rot
        case disease.contains("rust"):
            return LeaFitColors.rust
        case disease.contains("sunburn"):
            return LeaFitColors.sunburn
        default:
            return Color.green
        }
    }
    
    var body: some View {
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
                        
                            .onTapGesture {
                                isFullScreen = true
                            }
                        
                        
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
                            .onTapGesture {
                                isFullScreen = true
                            }
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
                                    .foregroundColor(displayColor(diseaseId))
                                
                                HStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(displayColor(diseaseId))
                                    
                                    Text(diseaseId.capitalized)
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
                    Text("Diagnose")
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
                                    Text("\(matchedItem.nameDisease)")
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
                                    HStack{
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(displayColor(matchedItem.nameDisease))
                                        
                                        Text("\(matchedItem.nameDisease)")
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                    }
                                    .padding(.top)

                                    Text("Prevention : ")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                    
                                    ForEach(matchedItem.prevention, id: \.preventionTitle) { prevention in
                                        Text(prevention.preventionTitle)
                                            .font(.system(size: 16, weight: .semibold, design: .default))
                                        
                                        Text(prevention.preventionDetail)
                                            .font(.system(size: 14, weight: .regular, design: .default))
                                    }
                                    
                                    Text("Watering : ")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                    
                                    ForEach(matchedItem.watering, id: \.wateringTips) { watering in
                                        ForEach(watering.wateringCondition, id: \.condition) { wateringCondition in
                                            Text("\(wateringCondition.condition) - \(wateringCondition.wateringFrequency) (Frequency) - \(wateringCondition.wateringVolume) (Volume) - \(wateringCondition.wateringNote) (Note)")
                                                .font(.system(size: 16, weight: .regular, design: .default))
                                        }
                                        
                                        Text(watering.wateringTips)
                                            .font(.system(size: 14, weight: .semibold, design: .default))
                                    }
                                    
                                    
                                    Text("Drying : ")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                    
                                    ForEach(matchedItem.drying, id: \.dryingTips) { drying in
                                        ForEach(drying.dryingCondition, id: \.plantCondition) { dryingCondition in
                                            Text("\(dryingCondition.plantCondition) - \(dryingCondition.dryingDuration) (Duration) - \(dryingCondition.dryingBestTime) (Best Time) - \(dryingCondition.dryingNote) (Note)")
                                                .font(.system(size: 16, weight: .regular, design: .default))
                                        }
                                        
                                        Text(drying.dryingTips)
                                            .font(.system(size: 14, weight: .semibold, design: .default))
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
}

//#Preview {
//    HealthyPlantSection()
//}

@ViewBuilder func buildMaskImage(mask: UIImage?) -> some View {
    if let mask {
        Image(uiImage: mask)
            .resizable()
            .antialiased(false)
            .interpolation(.none)
    }
}


//@ViewBuilder func buildMasksSheet(maskPredictions: [MaskPrediction] ) -> some View {
//    ScrollView {
//        LazyVStack(alignment: .center, spacing: 8) {
//            ForEach(Array(maskPredictions.enumerated()), id: \.offset) { index, maskPrediction in
//                VStack(alignment: .center) {
//                    Group {
//                        if let maskImg = maskPrediction.getMaskImage() {
//                            Image(uiImage: maskImg)
//                                .resizable()
//                                .antialiased(false)
//                                .interpolation(.none)
//                                .aspectRatio(contentMode: .fit)
//                                .background(Color.black)
//                                .contextMenu {
//                                    Button(action: {
//                                        UIImageWriteToSavedPhotosAlbum(maskImg, nil, nil, nil)
//                                    }) {
//                                        Label("Save to camera roll", systemImage: "square.and.arrow.down")
//                                    }
//                                }
//                        } else {
//                            let _ = print("maskImg is nil")
//                        }
//                    }
//                    Divider()
//                }.frame(maxWidth: .infinity, alignment: .center)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .padding()
//    }
//}
