//
//  JournalResultModalView.swift
//  LeaFit
//
//  Created by FWZ on 18/06/25.
//

import SwiftUI

struct JournalResultModalView: View {
    let entry: JournalEntry
    @Environment(\.dismiss) private var dismiss
    @State private var isFullScreen = false
    @State private var showDiagnose = true
    @State private var showDiagnoseExplanation = false
    @State private var showTreatmentExplanation = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    // Image section similar to ResultView
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LeaFitColors.light)
                        .frame(height: 224)
                        .overlay(
                            HStack(spacing: 16) {
                                // Original image
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .opacity(0.2)
                                    .frame(width: 175, height: 175)
                                    .overlay(
                                        Image(uiImage: entry.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 175, height: 175)
                                    )
                                    .onTapGesture {
                                        isFullScreen = true
                                    }
                                
                                // Processed image (using same dummy image)
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .opacity(0.2)
                                    .frame(width: 175, height: 175)
                                    .overlay(
                                        Image(uiImage: entry.image)
                                            .resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    )
                                    .onTapGesture {
                                        isFullScreen = true
                                    }
                            }
                        )
                    
                    // Diagnosis section
                    DisclosureGroup(
                        isExpanded: $showDiagnose,
                        content: {
                            VStack(alignment: .leading, spacing: 4) {
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(Array(entry.diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, score in
                                        Text("\(String(format: "%.2f", score * 100))%")
                                            .font(.system(size: 48, weight: .bold, design: .default))
                                            .foregroundColor(diseaseId == "Healthy" ? LeaFitColors.green : .orange)
                                        
                                        HStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(diseaseId == "Healthy" ? LeaFitColors.green : .orange)
                                            
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
                            Text("Diagnosis")
                                .font(.system(size: 24, weight: .semibold, design: .default))
                        }
                    )
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(LeaFitColors.light))
                    .accentColor(LeaFitColors.primary)
                    
                    // About These Diseases section
                    DisclosureGroup(
                        isExpanded: $showDiagnoseExplanation,
                        content: {
                            VStack(alignment: .leading) {
                                Divider()
                                
                                ForEach(Array(entry.diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, _ in
                                    if let matchedItem = diseases.first(where: { $0.diseaseId == diseaseId }) {
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
                    
                    // Treatment section (if diseases are not "Healthy")
                    if !entry.diseases.keys.contains("Healthy") {
                        DisclosureGroup(
                            isExpanded: $showTreatmentExplanation,
                            content: {
                                VStack(alignment: .leading) {
                                    Divider()
                                    
                                    ForEach(Array(entry.diseases.sorted(by: { $0.value > $1.value })), id: \.key) { diseaseId, _ in
                                        if let matchedItem = diseases.first(where: { $0.diseaseId == diseaseId }) {
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
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .background(LeaFitColors.background)
        }
    }
}

//#Preview {
//    JournalResultModalView()
//}
