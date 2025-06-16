//
//  DetailPotView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 14/06/25.
//

import SwiftUI
import Foundation

struct DetailPotView: View {
    
        let pot: Pot
    
        @State private var showTakePicturePopup = false
        
        var body: some View {
            ZStack {
                Color.appBackgroundColor.ignoresSafeArea()
               
                VStack {
                    if !pot.leaves.isEmpty {
                        //
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(pot.leaves, id: \.id) { leaf in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 120)
                                        .overlay(
                                            Text("Leaf Image")
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        Spacer().frame(height: 170)
                        Image("EmptyCategoryLogo2")
                        Text("\(pot.namePot) is empty")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                        Text("Start by adding pictures of your plants!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Button (action: {
                                showTakePicturePopup = true
                            } ) {
                                Image(systemName: "camera")
                                    .foregroundColor(Color(hex: "428D6D"))
                                    .padding(.trailing, -4)
                                    .padding(.top, 2)
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                                Text("Take Picture")
                                    .foregroundColor(Color(hex: "428D6D"))
                                    .padding(.top, 2)
                                    .font(.system(size: 17, weight: .semibold, design: .default))
                            }
                        }
                        Spacer()
                    }
                    
                    if !pot.leaves.isEmpty {
                        Button (action: {
                            showTakePicturePopup = true
                        } ) {
                            HStack {
                                Image(systemName: "camera")
                                    .foregroundColor(Color(hex: "428D6D"))
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                                Text("Take New Picture")
                                    .foregroundColor(Color(hex: "428D6D"))
                                    .font(.system(size: 17, weight: .semibold, design: .default))
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle(pot.namePot)
            .navigationBarTitleDisplayMode(.large)
            .scrollContentBackground(.hidden)
            .background(Color.appBackgroundColor.ignoresSafeArea())
          
        }
    }

    #Preview {
            DetailPotView(pot: Pot(id: UUID(), namePot: "My Aloe Plant", leaves: []))
    }

