////
////  Plant.swift
////  LeaFit
////
////  Created by Yonathan Hilkia on 12/06/25.
////
//
import Foundation
import SwiftUI
import SwiftData


@Model
class PlantCategory {
    let id: UUID
    var name: String
    var nameScientific: String
    @Relationship var pots: [Pot]

    
    init(id: UUID = UUID(), name: String, nameScientific: String, pots: [Pot] = []) {
        self.id = id
        self.name = name
        self.nameScientific = nameScientific
        self.pots = pots
    }
}

@Model
class Pot {
    let id: UUID
    var namePot: String
    @Relationship var leaves: [Leaf]
    @Relationship (inverse: \PlantCategory.pots) var plantCategory: PlantCategory?
    
    init(id: UUID = UUID(), namePot: String, leaves: [Leaf], plantCategory: PlantCategory? = nil) {
        self.id = id
        self.namePot = namePot
        self.leaves = leaves
        self.plantCategory = plantCategory
    }
}

@Model
class Leaf {
    let id: UUID
    var originalImage: Data
    var processedImage: Data
    var leafNote: String? = ""
    var dateCreated: Date
    @Relationship var diagnose: Diagnose
    @Relationship (inverse: \Pot.leaves) var pot: Pot?
    
    init(id: UUID = UUID(), originalImage: Data, processedImage: Data, leafNote: String, dateCreated: Date, diagnose: Diagnose, pot: Pot? = nil) {
        self.id = id
        self.originalImage = originalImage
        self.processedImage = processedImage
        self.leafNote = leafNote
        self.dateCreated = dateCreated
        self.diagnose = diagnose
        self.pot = pot
    }
}

@Model
class Diagnose {
    let id: UUID
    var confidenceScore: Int
    var diseaseId: String
    @Relationship (inverse: \Leaf.diagnose) var leaf: Leaf?
    
    init(id: UUID = UUID(), confidenceScore: Int, diseaseId: String, leaf: Leaf? = nil) {
        self.id = id
        self.confidenceScore = confidenceScore
        self.diseaseId = diseaseId
        self.leaf = leaf
    }
    
}
