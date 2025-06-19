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
    @Attribute var id: UUID
    @Attribute var imageName: String
    @Attribute var title: String
    @Attribute var nameScientific: String
    @Relationship var pots: [Pot]

    init(id: UUID = UUID(), imageName: String, title: String, nameScientific: String, pots: [Pot] = []) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.nameScientific = nameScientific
        self.pots = pots
    }
}

@Model
class Pot {
    @Attribute var id: UUID
    @Attribute var namePot: String
    @Relationship var leaves: [Leaf]
    @Relationship(inverse: \PlantCategory.pots) var plantCategory: PlantCategory?
    
    init(id: UUID = UUID(), namePot: String, leaves: [Leaf], plantCategory: PlantCategory? = nil) {
        self.id = id
        self.namePot = namePot
        self.leaves = leaves
        self.plantCategory = plantCategory
    }
}

@Model
class Leaf {
    @Attribute var id: UUID
    @Attribute var originalImage: Data
    @Attribute var processedImage: Data
    @Attribute var maskImage: Data
    @Attribute var leafNote: String? = ""
    @Attribute var dateCreated: Date
    @Relationship var diagnose: [Diagnose]
    @Relationship(inverse: \Pot.leaves) var pot: Pot?
    
    init(id: UUID = UUID(), originalImage: Data, processedImage: Data, maskImage: Data, leafNote: String, dateCreated: Date, diagnose: [Diagnose], pot: Pot? = nil) {
        self.id = id
        self.originalImage = originalImage
        self.processedImage = processedImage
        self.maskImage = maskImage
        self.leafNote = leafNote
        self.dateCreated = dateCreated
        self.diagnose = diagnose
        self.pot = pot
    }
}

@Model
class Diagnose {
    @Attribute var id: UUID
    @Attribute var confidenceScore: Int
    @Attribute var diseaseId: String
    @Relationship(inverse: \Leaf.diagnose) var leaf: Leaf?
    
    init(id: UUID = UUID(), confidenceScore: Int, diseaseId: String, leaf: Leaf? = nil) {
        self.id = id
        self.confidenceScore = confidenceScore
        self.diseaseId = diseaseId
        self.leaf = leaf
    }
    
}
