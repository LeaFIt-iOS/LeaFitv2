//
//  CategoriesViewModel.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import Foundation
import SwiftUI

struct PlantCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let plants: [String]
}

class CategoriesViewModel: ObservableObject {
    private let myCategories: [PlantCategory] = [
        PlantCategory(name: "Sinarmas", plants: ["Monstera", "Palm"]),
        PlantCategory(name: "GOP9", plants: ["Abece","Moa", "Pal"])
    ]
    
    var allPlants: [String] {
        myCategories.flatMap { $0.plants }.sorted()
    }
    
    func filteredCategories(searchText: String) -> [PlantCategory] {
        if searchText.isEmpty {
            return myCategories
        } else {
            return myCategories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
