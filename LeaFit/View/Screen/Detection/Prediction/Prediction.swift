//
//  Prediction.swift
//  YOLOv8-seg-iOS
//
//  Created by Marcel Opitz on 25.06.23.
//

import Foundation

// MARK: Prediction
struct Prediction: Identifiable {
    let id = UUID()
    
    let classIndex: Int
    let score: Float
    let xyxy: XYXY
    let maskCoefficients: [Float]
    
    let inputImgSize: CGSize
    var diseaseId: String { className[classIndex] }
  
    static var zero: Prediction {
        return Prediction(
            classIndex: 0,
            score: 0,
            xyxy: .init(x1: 0, y1: 0, x2: 0, y2: 0),
            maskCoefficients: [],
            inputImgSize: .zero
//            label
        )
    }
}

extension XYXY: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x1), \(y1)), (\(x2), \(y2))"
    }
}
