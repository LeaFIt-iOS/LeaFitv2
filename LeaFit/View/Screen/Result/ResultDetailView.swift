//
//  ResultDetailView.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 14/06/25.
//

import SwiftUI

struct ResultDetailView: View {
    private var originalImage: UIImage
    private var resultImage: UIImage
    
    init(originalImage: UIImage, resultImage: UIImage) {
        self.originalImage = originalImage
        self.resultImage = resultImage
    }
    
    @State private var viewModel: ResultDetailViewModel = ResultDetailViewModel()
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                TabView {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray)
                        .opacity(0.2)
                        .frame(height: 393)
                        .overlay(
                            Image(uiImage: originalImage).resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 393)
                        )
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray)
                        .opacity(0.2)
                        .frame(height: 393)
                        .overlay(
                            Image(uiImage: resultImage).resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 393)
                        )
                }
                .frame(height: 393)
                .tabViewStyle(.page)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(height: 170)
                    .overlay(
                        VStack(alignment: .leading) {
                            DatePicker(
                                "Time",
                                selection: $viewModel.date,
                                displayedComponents: [.date]
                            )
                            
                            Divider()
                            
                            List {
                                Picker(selection: $viewModel.selectedPot) {
                                    ForEach(viewModel.pots, id: \.self) { pot in
                                        Text(pot.rawValue.capitalized)
                                    }
                                } label: {
                                    Text("Pot")
                                }
                                .listRowInsets(EdgeInsets())
                            }
                            .listStyle(PlainListStyle())
                            
                            HStack {
                                Text("Notes")
                                
                                TextField(text: $viewModel.notes) {
                                    Text("Add Notes")
                                }
                                .multilineTextAlignment(.trailing)
                            }
                        }
                            .padding()
                    )
                    .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Text("Save")
                }
            }
        }
        .accentColor(LeaFitColors.primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LeaFitColors.background)

    }
}
