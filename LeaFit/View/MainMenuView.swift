//
//  MainMenuView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import SwiftUI

struct MainMenuView: View {
    
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: "428D6D")]
            let toolbarAppearance = UIToolbarAppearance()
                toolbarAppearance.configureWithOpaqueBackground()
                toolbarAppearance.backgroundColor = UIColor(hex: "BEDCBA")
                UIToolbar.appearance().standardAppearance = toolbarAppearance
                UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance
    }
    
    @StateObject private var categoriesViewModel = CategoriesViewModel()
    @State var searchPlaceholder = ""
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PlantListView(plants: categoriesViewModel.allPlants, title: "All Plants")) {
                    HStack {
                        Image(systemName: "apple.meditate")
                        Text("All Plants")
                            .foregroundColor(.primary)
                            .bold()
                        Spacer()
                        Text("\(categoriesViewModel.allPlants.count)")
                    }
                    .padding(.vertical, 4)
                    .bold()
                    
                }
                HStack {
                    Image(systemName: "plus.circle")
                        .bold()
                    Text("Add Categories")
                        .foregroundColor(.primary)
                        .bold()
                }
                
                Section(header: Text("My Categories")
                    .font(.headline)
                    .foregroundColor(.primary)) {
                        let filtered = categoriesViewModel.filteredCategories(searchText: searchPlaceholder)
                        
                        if filtered.isEmpty {
                            Text("No results found")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(filtered) { category in
                                NavigationLink(destination: PlantListView(plants: category.plants, title: category.name)) {
                                    HStack {
                                        Image(systemName: "leaf")
                                            .bold()
                                        Text(category.name)
                                            .foregroundColor(.primary)
                                            .bold()
                                        Spacer()
                                        Text("\(category.plants.count)")
                                        
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
            }
            
            .navigationTitle("LeaFit")
            .navigationBarItems(trailing: EditButton())
            .foregroundColor(Color(hex: "428D6D"))
            
            .searchable(text: $searchPlaceholder, placement: .navigationBarDrawer(displayMode: .automatic))
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack{
                    Button(action: {
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color(hex: "428D6D"))
                    }
                    Spacer()
                    Button(action: {
                    }) {
                        Image(systemName: "camera")
                            .foregroundStyle(Color(hex: "428D6D"))
                    }
                }
            }
        }
    }
}



#Preview {
    MainMenuView()
}
