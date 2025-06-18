//
//  JournalResultModalView.swift
//  LeaFit
//
//  Created by FWZ on 18/06/25.
//

import SwiftUI

struct JournalResultModalView: View {
    let entry: Leaf
    @Environment(\.dismiss) private var dismiss
    @State private var isFullScreen = false
    @State private var showDiagnose = true
    @State private var showDiagnoseExplanation = false
    @State private var showTreatmentExplanation = false
    
    // Computed properties to break up complex expressions
    private var originalImage: UIImage? {
        UIImage(data: entry.originalImage)
    }
    
    private var processedImage: UIImage? {
        UIImage(data: entry.processedImage)
    }
    
    private var sortedDiagnoses: [Diagnose] {
        entry.diagnose.sorted(by: { $0.confidenceScore > $1.confidenceScore })
    }
    
    private var diseasesDictionary: [String: Double] {
        var dict: [String: Double] = [:]
        for diagnose in entry.diagnose {
            dict[diagnose.diseaseId] = Double(diagnose.confidenceScore) / 100.0
        }
        return dict
    }
    
    private var hasHealthyDiagnosis: Bool {
        entry.diagnose.contains { $0.diseaseId == "Healthy" }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    ImageSectionView(
                        originalImage: originalImage,
                        processedImage: processedImage,
                        onImageTap: { isFullScreen = true }
                    )
                    
                    DiagnosisSectionView(
                        diagnoses: sortedDiagnoses,
                        isExpanded: $showDiagnose
                    )
                    
                    DiseaseExplanationSectionView(
                        diseases: diseasesDictionary,
                        isExpanded: $showDiagnoseExplanation
                    )
                    
                    if !hasHealthyDiagnosis {
                        TreatmentSectionView(
                            diseases: diseasesDictionary,
                            isExpanded: $showTreatmentExplanation
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Diagnosis Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(entry.dateCreated, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .background(LeaFitColors.background)
        }
    }
}

// MARK: - Image Section Component
struct ImageSectionView: View {
    let originalImage: UIImage?
    let processedImage: UIImage?
    let onImageTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(LeaFitColors.light)
            .frame(height: 224)
            .overlay(
                HStack(spacing: 16) {
                    OriginalImageView(image: originalImage, onTap: onImageTap)
                    ProcessedImageView(image: processedImage, onTap: onImageTap)
                }
            )
    }
}

// MARK: - Original Image Component
struct OriginalImageView: View {
    let image: UIImage?
    let onTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.gray)
            .opacity(0.2)
            .frame(width: 175, height: 175)
            .overlay(
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                    }
                }
            )
            .onTapGesture {
                onTap()
            }
    }
}

// MARK: - Processed Image Component
struct ProcessedImageView: View {
    let image: UIImage?
    let onTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.gray)
            .opacity(0.2)
            .frame(width: 175, height: 175)
            .overlay(
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            )
            .onTapGesture {
                onTap()
            }
    }
}

// MARK: - Diagnosis Section Component
struct DiagnosisSectionView: View {
    let diagnoses: [Diagnose]
    @Binding var isExpanded: Bool
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading, spacing: 4) {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(diagnoses, id: \.id) { diagnose in
                            DiagnosisItemView(diagnose: diagnose)
                        }
                        
                        Divider()
                        
                        DisclaimerTextView()
                    }
                    .padding()
                }
                .padding(.top, 4)
            },
            label: {
                Text("Diagnosis")
                    .font(.system(size: 24, weight: .semibold, design: .default))
            }
        )
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
        .accentColor(LeaFitColors.primary)
    }
}

// MARK: - Diagnosis Item Component
struct DiagnosisItemView: View {
    let diagnose: Diagnose
    
    private var displayColor: Color {
        let disease = diagnose.diseaseId.lowercased()
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
    
    private var percentageText: String {
        "\(diagnose.confidenceScore)%"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(percentageText)
                .font(.system(size: 48, weight: .bold, design: .default))
                .foregroundColor(displayColor)
            
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(displayColor)
                
                Text(diagnose.diseaseId.capitalized)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundColor(LeaFitColors.primary)
            }
        }
    }
}

// MARK: - Disclaimer Text Component
struct DisclaimerTextView: View {
    var body: some View {
        Text("This prediction is based solely on the image and may not be accurate. For a definitive diagnosis and further information, please consult an expert or conduct additional research independently.")
            .font(.system(size: 14, weight: .regular, design: .default))
            .foregroundColor(LeaFitColors.textGrey)
    }
}

// MARK: - Disease Explanation Section Component
struct DiseaseExplanationSectionView: View {
    let diseases: [String: Double]
    @Binding var isExpanded: Bool
    
    private var sortedDiseases: [(String, Double)] {
        Array(diseases.sorted(by: { $0.value > $1.value }))
    }
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading) {
                    Divider()
                    
                    ForEach(sortedDiseases, id: \.0) { diseaseId, _ in
                        DiseaseExplanationItemView(diseaseId: diseaseId)
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
    }
}

// MARK: - Disease Explanation Item Component
struct DiseaseExplanationItemView: View {
    let diseaseId: String
    
    private var matchedDisease: Disease? {
        diseases.first(where: { $0.diseaseId == diseaseId })
    }
    
    var body: some View {
        Group {
            if let disease = matchedDisease {
                VStack(alignment: .leading, spacing: 12) {
                    Text("[\(disease.nameDisease)]")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding(.top)
                    
                    Text(disease.explanation)
                        .font(.system(size: 14, weight: .regular, design: .default))
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Treatment Section Component
struct TreatmentSectionView: View {
    let diseases: [String: Double]
    @Binding var isExpanded: Bool
    
    private var sortedDiseases: [(String, Double)] {
        Array(diseases.sorted(by: { $0.value > $1.value }))
    }
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading) {
                    Divider()
                    
                    ForEach(sortedDiseases, id: \.0) { diseaseId, _ in
                        TreatmentItemView(diseaseId: diseaseId)
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

// MARK: - Treatment Item Component
struct TreatmentItemView: View {
    let diseaseId: String
    
    private var matchedDisease: Disease? {
        diseases.first(where: { $0.diseaseId == diseaseId })
    }
    
    var body: some View {
        Group {
            if let disease = matchedDisease {
                VStack(alignment: .leading, spacing: 12) {
                    Text("[\(disease.nameDisease)]")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding(.top)
                    
                    PreventionSectionView(preventions: disease.prevention)
                    WateringSectionView(waterings: disease.watering)
                    DryingSectionView(dryings: disease.drying)
                    
                    Divider()
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Prevention Section Component
struct PreventionSectionView: View {
    let preventions: [Prevention]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Prevention : ")
                .font(.system(size: 14, weight: .semibold, design: .default))
            
            ForEach(preventions, id: \.preventionTitle) { prevention in
                VStack(alignment: .leading, spacing: 4) {
                    Text(prevention.preventionTitle)
                        .font(.system(size: 12, weight: .semibold, design: .default))
                    
                    Text(prevention.preventionDetail)
                        .font(.system(size: 10, weight: .regular, design: .default))
                }
            }
        }
    }
}

// MARK: - Watering Section Component
struct WateringSectionView: View {
    let waterings: [Watering]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Watering : ")
                .font(.system(size: 14, weight: .semibold, design: .default))
            
            ForEach(waterings, id: \.wateringTips) { watering in
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(watering.wateringCondition, id: \.condition) { condition in
                        WateringConditionView(condition: condition)
                    }
                    
                    Text(watering.wateringTips)
                        .font(.system(size: 10, weight: .semibold, design: .default))
                }
            }
        }
    }
}

// MARK: - Watering Condition Component
struct WateringConditionView: View {
    let condition: WateringCondition
    
    private var conditionText: String {
        "\(condition.condition) - \(condition.wateringFrequency) (Frequency) - \(condition.wateringVolume) (Volume) - \(condition.wateringNote) (Note)"
    }
    
    var body: some View {
        Text(conditionText)
            .font(.system(size: 12, weight: .semibold, design: .default))
    }
}

// MARK: - Drying Section Component
struct DryingSectionView: View {
    let dryings: [Drying]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drying : ")
                .font(.system(size: 14, weight: .semibold, design: .default))
            
            ForEach(dryings, id: \.dryingTips) { drying in
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(drying.dryingCondition, id: \.plantCondition) { condition in
                        DryingConditionView(condition: condition)
                    }
                    
                    Text(drying.dryingTips)
                        .font(.system(size: 10, weight: .semibold, design: .default))
                }
            }
        }
    }
}

// MARK: - Drying Condition Component
struct DryingConditionView: View {
    let condition: DryingCondition
    
    private var conditionText: String {
        "\(condition.plantCondition) - \(condition.dryingDuration) (Duration) - \(condition.dryingBestTime) (Best Time) - \(condition.dryingNote) (Note)"
    }
    
    var body: some View {
        Text(conditionText)
            .font(.system(size: 12, weight: .semibold, design: .default))
    }
}

//#Preview {
//    JournalResultModalView()
//}
