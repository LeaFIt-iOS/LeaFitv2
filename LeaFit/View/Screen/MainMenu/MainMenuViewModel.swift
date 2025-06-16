
//  CategoriesViewModel.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import Foundation
import SwiftUI
import SwiftData

class MainMenuViewModel: ObservableObject {
    @Published private(set) var categories: [PlantCategory] = []
    private var modelContext: ModelContext?
    
//    var allPlants: [String] {
//        categories.flatMap { $0.plants }.sorted()
//    }
    
    var allCategories: [PlantCategory] {
        categories
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context

        do {
            // Check if any PlantCategory already exists in persistent store
            let descriptor = FetchDescriptor<PlantCategory>()
            let existing = try context.fetchCount(descriptor)

            if existing == 0 {
                let initialCategories = [
                    PlantCategory(imageName: "img-aloevera", title: "Aloe Vera", nameScientific: ""),
                    PlantCategory(imageName: "img-kaktus", title: "Cactus", nameScientific: ""),
                    PlantCategory(imageName: "img-rose", title: "Rose", nameScientific: ""),
                    PlantCategory(imageName: "img-monstera", title: "Monstera", nameScientific: ""),
                    PlantCategory(imageName: "img-bonsai", title: "Bonsai", nameScientific: ""),
                    PlantCategory(imageName: "img-jasmine", title: "Jasmine", nameScientific: ""),
                    PlantCategory(imageName: "img-sanse", title: "Sansevieria", nameScientific: "")
                ]

                for category in initialCategories {
                    context.insert(category)
                    print("✅ Inserted: \(category.title)")
                }

                try context.save()
                print("✅ Seeded initial categories.")
                
                let all = try context.fetch(FetchDescriptor<PlantCategory>())
                print("📦 After seeding, fetch found \(all.count) categories")
            } else {
                print("ℹ️ Categories already exist in the store.")
            }
        } catch {
            print("❌ Error checking/seeding data: \(error)")
        }

        fetchCategories()
    }
    
    private func fetchCategories() {
        do {
            let descriptor = FetchDescriptor<PlantCategory>(sortBy: [SortDescriptor(\.title)])
            categories = try modelContext?.fetch(descriptor) ?? []

            // Debug output
            print("✅ Fetched \(categories.count) categories:")
            categories.forEach { category in
                print("→ \(category.title) [\(category.id)]")
            }

        } catch {
            print("❌ Failed to fetch categories: \(error)")
        }
    }
    
    func filteredCategories(searchText: String) -> [PlantCategory] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
//    func addCategory(name: String, plants: [String]) {
//        guard let context = modelContext else { return }
//        guard name.count <= 24 else { return }
//        guard !categoryExists(name: name) else { return }
//
//        let newCategory = PlantCategory(name: name, plants: plants)
//        context.insert(newCategory)
//
//        do {
//            try context.save()
//            fetchCategories()
//        } catch {
//            print("Failed to save category: \(error)")
//        }
//    }
    
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
        
        category.title = newName
        
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
            return category.title.lowercased() == name.lowercased()
        }
    }
   
    func categoryImageName(for categoryName: String) -> String {
            switch categoryName.lowercased() {
            case "aloe vera":
                return "emotaloe"
            case "cactus":
                return "img-kaktus"
            case "rose":
                return "img-rose"
            default:
                return "emotaloe" // Fallback image
            }
        }
}
