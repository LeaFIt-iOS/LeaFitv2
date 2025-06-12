//
//  Disease.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 12/06/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Disease {
    var nameDisease: String
    @Relationship  var prevention: [Prevention]
    @Relationship  var watering: [Watering]
    @Relationship  var drying: [Drying]
    var colorHex: String
    
    init(nameDisease: String, prevention: [Prevention], watering: [Watering], drying: [Drying], colorHex: String) {
        self.nameDisease = nameDisease
        self.prevention = prevention
        self.watering = watering
        self.drying = drying
        self.colorHex = colorHex
    }
}

@Model
class Drying {
    @Relationship var dryingCondition: [DryingCondition]
    var dryingTips: String
    @Relationship (inverse: \Disease.drying) var disease: Disease?
    
    init(dryingCondition: [DryingCondition], dryingTips: String, disease: Disease? = nil) {
        self.dryingCondition = dryingCondition
        self.dryingTips = dryingTips
        self.disease = disease
    }
}

@Model
class DryingCondition {
    var plantCondition: String
    var dryingDuration: String
    var dryingBestTime: String
    var dryingNote: String
    @Relationship (inverse: \Drying.dryingCondition) var drying: Drying?
    
    
    init(plantCondition: String, dryingDuration: String, dryingBestTime: String, dryingNote: String, drying: Drying? = nil) {
        self.plantCondition = plantCondition
        self.dryingDuration = dryingDuration
        self.dryingBestTime = dryingBestTime
        self.dryingNote = dryingNote
        self.drying = drying
    }
}

@Model
class Watering {
    @Relationship var wateringCondition: [WateringCondition]
    var wateringTips: String
    @Relationship (inverse: \Disease.watering) var disease: Disease?

    init(wateringCondition: [WateringCondition], wateringTips: String, disease: Disease? = nil) {
        self.wateringCondition = wateringCondition
        self.wateringTips = wateringTips
        self.disease = disease
    }
}

@Model
class WateringCondition {
    var weather: String
    var wateringFrequency: String
    var wateringVolume: String
    var wateringNote: String
    @Relationship (inverse: \Watering.wateringCondition) var watering: Watering?
    
    init(weather: String, wateringFrequency: String, wateringVolume: String, wateringNote: String, watering: Watering? = nil) {
        self.weather = weather
        self.wateringFrequency = wateringFrequency
        self.wateringVolume = wateringVolume
        self.wateringNote = wateringNote
        self.watering = watering
    }
}

@Model
class Prevention {
    var preventionTitle: String
    var preventionDetail: String
    @Relationship (inverse: \Disease.prevention) var disease: Disease?
    
    init(preventionTitle: String, preventionDetail: String, disease: Disease? = nil) {
        self.preventionTitle = preventionTitle
        self.preventionDetail = preventionDetail
        self.disease = disease
    }
}
