//
//  CameraViewModel.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 13/06/25.
//

import Foundation
import AVFoundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import CoreML

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var model: VNCoreMLModel?
    private var device: AVCaptureDevice?
    private var isConfigured: Bool = false
    
    @Published var isAloeDetected: Bool = false
    @Published var isCapturing: Bool = false
    @Published var capturedImage: UIImage?
    @Published var originalImage: UIImage?
    @Published var isSessionRunning: Bool = false
    @Published var isTorchOn: Bool = false
    
    override init() {
        super.init()
        setupModel()
        setupCamera()
    }
    
    private func setupModel() {
        do {
            model = try VNCoreMLModel(for: AloeImageClassifier().model)
        } catch {
            print("❌ Failed to load model: \(error)")
        }
    }
    
    private func setupCamera() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            print("❌ Cannot add camera input")
            session.commitConfiguration()
            return
        }
        
        session.addInput(input)
        
        // ✅ Add photo output
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            print("❌ Cannot add photo output")
        }
        
        // ✅ Add video output for real-time classification
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        } else {
            print("❌ Cannot add video output")
        }
        
        session.commitConfiguration()
        Task {
            self.session.startRunning()
        }
        
        isConfigured = true
    }
    
    func startSession() {
        guard isConfigured else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }
    
    func capturePhoto() {
        guard !isCapturing else {
            return
        }
        
        isCapturing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if self.isCapturing {
                self.isCapturing = false
            }
        }
        
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let rawImage = UIImage(data: data) else {
            print("❌ Could not get image data")
            isCapturing = false
            return
        }
        
        let orientedImage = fixOrientation(for: rawImage)
        
        removeBackground(from: orientedImage) { [weak self] result in
            DispatchQueue.main.async {
                self?.originalImage = orientedImage
                self?.capturedImage = result
                self?.isCapturing = false
                print("✅ Captured and processed image")
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let model = model,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }
            
            DispatchQueue.main.async {
                // Result
                self?.isAloeDetected = topResult.identifier == "aloe"
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? handler.perform([request])
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.capturedImage = nil
            self.isCapturing = false
            
            if !self.session.isRunning {
                self.startSession()
            }
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if on {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
            isTorchOn = on
        } catch {
            print("Torch could not be used")
        }
    }
    
    private func fixOrientation(for image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    private func removeBackground(from inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let ciInput = CIImage(image: inputImage) else {
            completion(inputImage)
            return
        }
        
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: ciInput)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
                guard let result = request.results?.first else {
                    completion(inputImage)
                    return
                }
                
                let mask = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                let ciMask = CIImage(cvPixelBuffer: mask)
                
                let filter = CIFilter.blendWithMask()
                filter.inputImage = ciInput
                filter.maskImage = ciMask
                filter.backgroundImage = CIImage.empty()
                
                if let outputImage = filter.outputImage {
                    let context = CIContext()
                    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                        completion(UIImage(cgImage: cgImage))
                        return
                    } else {
                        print("❌ Could not create CGImage — returning original")
                    }
                } else {
                    print("❌ Blend filter failed — returning original")
                }
            } catch {
                print("❌ Vision error: \(error.localizedDescription) — returning original")
            }
            
            completion(inputImage)
        }
    }
}
