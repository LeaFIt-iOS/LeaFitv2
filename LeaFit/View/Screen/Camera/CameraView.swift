//
//  CameraView.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 12/06/25.
//

import SwiftUI
import AVFoundation
import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct CameraView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var showCaptureAlert: Bool = false
    @StateObject private var viewModel = CameraViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if let image = capturedImage {
                CameraResultView(
                    image: image,
                    originalImage: viewModel.originalImage!,
                    onRetake: {
                        withAnimation {
                            capturedImage = nil
                            
                            viewModel.reset()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.startSession()
                        }
                    },
                    detectionViewModel: ContentViewModel()
                )
            } else {
                ZStack {
                    CameraPreview(session: viewModel.session)
                        .ignoresSafeArea()
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.5))
                        
                        Rectangle()
                            .blendMode(.destinationOut)
                            .overlay(
                                Image("img-camera-border")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(viewModel.isAloeDetected ? .green : .red)
                                
                            )
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                        
                        VStack {
                                Text(viewModel.isAloeDetected ? "Aloe Found!" : "Aloe Not Found!")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(viewModel.isAloeDetected ? LeaFitColors.primary : .white)
                                    .padding(.top, 40)

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .compositingGroup()
                    .padding(.bottom, 80)
                    
                    VStack {
                        Spacer()
                        
                        HStack() {
                            Spacer()
                            
                            Button(action: {
                                if viewModel.isAloeDetected {
                                    viewModel.capturePhoto()
                                } else {
                                    showCaptureAlert = true
                                }
                            }) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 69, height: 69)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2).frame(width: 78, height: 78)
                                    )
                            }
                            
                            Button(action: {
                                print("!viewModel.isTorchOn: \(!viewModel.isTorchOn)")
                                viewModel.toggleTorch(on: !viewModel.isTorchOn)
                            }) {
                                Image(systemName: viewModel.isTorchOn ? "bolt.fill" : "bolt.slash")
                                    .font(.system(size: 24))
                                    .padding()
                                    .background(Circle().fill(Color.white.opacity(0.8)))
                            }
                            .padding(.leading, 90)
                        }
                        .padding(.vertical, 40)
                        .padding(.horizontal, 10)
                        .background(Color.black)
                    }
                    
                    if viewModel.isCapturing {
                        ZStack {
                            Color.black.opacity(0.5).ignoresSafeArea()
                            ProgressView("Processing...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(12)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
                }
                .alert("Sorry, aloe vera not found!", isPresented: $showCaptureAlert) {
                    Button("Retake", role: .cancel) { }
                } message: {
                    Text("Please take a photo in when bounding box is green.")
                }
            }
        }
        .background(Color.black)
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .onReceive(viewModel.$capturedImage) { newImage in
            guard let image = newImage else { return }
            withAnimation {
                capturedImage = image
            }
        }
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .accentColor(.white)
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        uiView.videoPreviewLayer.connection?.videoOrientation = .portrait
    }
}

final class CameraPreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
