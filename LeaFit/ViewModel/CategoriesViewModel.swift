//
//  CategoriesViewModel.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class PlantCategory: Identifiable {
    let id: UUID
    var name: String
    var plants: [String]
    
    init(id: UUID = UUID(), name: String, plants: [String]) {
        self.id = id
        self.name = name
        self.plants = plants
    }
}

class CategoriesViewModel: ObservableObject {
    @Published private var categories: [PlantCategory] = []
    private var modelContext: ModelContext?
    
    var allPlants: [String] {
        categories.flatMap { $0.plants }.sorted()
    }
    
    var allCategories: [PlantCategory] {
        categories
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchCategories()
        
        // Seed initial data if empty
        if categories.isEmpty {
            let initialCategories = [
                PlantCategory(name: "Sinarmas", plants: ["Monstera", "Palm"]),
                PlantCategory(name: "GOP9", plants: ["Abece", "Moa", "Pal"])
            ]
            initialCategories.forEach { category in
                modelContext?.insert(category)
            }
            try? modelContext?.save()
            fetchCategories()
        }
    }
    
    private func fetchCategories() {
        do {
            let descriptor = FetchDescriptor<PlantCategory>(sortBy: [SortDescriptor(\.name)])
            categories = try modelContext?.fetch(descriptor) ?? []
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func filteredCategories(searchText: String) -> [PlantCategory] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func addCategory(name: String, plants: [String]) {
        guard let context = modelContext else { return }
        guard name.count <= 24 else { return }
        guard !categoryExists(name: name) else { return }
        
        let newCategory = PlantCategory(name: name, plants: plants)
        context.insert(newCategory)
        
        do {
            try context.save()
            fetchCategories()
        } catch {
            print("Failed to save category: \(error)")
        }
    }
    
    func deleteCategory(_ category: PlantCategory) {
        guard let context = modelContext else { return }
        context.delete(category)
        
        do {
            try context.save()
            fetchCategories()
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
    
    func renameCategory(_ category: PlantCategory, newName: String) {
        guard let context = modelContext else { return }
        guard newName.count <= 24 else { return }
        guard !categoryExists(name: newName, excluding: category) else { return }
        
        category.name = newName
        
        do {
            try context.save()
            fetchCategories()
        } catch {
            print("Failed to rename category: \(error)")
        }
    }
    
    func categoryExists(name: String, excluding: PlantCategory? = nil) -> Bool {
        return categories.contains { category in
            if let excluding = excluding, category.id == excluding.id {
                return false
            }
            return category.name.lowercased() == name.lowercased()
        }
    }
}
