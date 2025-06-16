import SwiftUI
import SwiftData

struct PotList: Identifiable {
    let id = UUID()
    let imageName: String
    let titles: String
    let destinationTitle: String
}

struct MainMenuView: View {
    @StateObject private var categoriesViewModel: CategoriesViewModel
    
    @State private var searchPlaceholder = ""
    @State private var selectedCategory: PlantCategory?
    @State private var isEditMode = false
    
    @Environment(\.modelContext) private var modelContext
    
    init(){
        let viewModel = CategoriesViewModel()
        _categoriesViewModel = StateObject(wrappedValue: viewModel)
    }
    
    let previewPlants: [PotList] = [
        PotList(imageName: "img-aloevera", titles: "Aloe Vera", destinationTitle: "Aloe Vera"),
        PotList(imageName: "img-kaktus", titles: "Cactus", destinationTitle: "Cactus"),
        PotList(imageName: "img-rose", titles: "Rose", destinationTitle: "Rose"),
        PotList(imageName: "img-monstera", titles: "Monstera", destinationTitle: "Monstera"),
        PotList(imageName: "img-bonsai", titles: "Bonsai", destinationTitle: "Bonsai"),
        PotList(imageName: "img-jasmine", titles: "Jasmine", destinationTitle: "Jasmine"),
        PotList(imageName: "img-sanse", titles: "Sansevieria", destinationTitle: "Sansevieria")
    ]
    
    var groupedPlants: [[PotList]] {
        stride(from: 0, to: previewPlants.count, by: 3).map {
            Array(previewPlants[$0..<min($0 + 3, previewPlants.count)])
        }
    }
    
    var body: some View {
        NavigationStack  {
            ZStack {
                ZStack {
                    Image("img-framejendela")
                        .padding(.top, 70)
                    VStack(spacing: -80) {
                        ForEach(Array(groupedPlants.enumerated()), id: \.offset) { _, group in
                            ZStack {
                                Image("img-rakpot")
                                    .padding(.top, 180)
                                HStack(spacing: 2) {
                                    ForEach(group) { plant in
                                        if plant.titles == "Aloe Vera" {
                                            NavigationLink(destination: PlantListView(pots: [], title: plant.destinationTitle)) {
                                                VStack(spacing: 0) {
                                                    Image(plant.imageName)
                                                        .resizable()
                                                        .frame(width: 113, height: 144)
                                                    Text(plant.titles)
                                                        .font(.system(size: 14, weight: .semibold, design: .default))
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                                .padding(.top, 40)

                                        } else {
                                                    NavigationLink(destination: UnavailablePotView(pots: [], title: plant.destinationTitle)) {
                                                        VStack(spacing: 0) {
                                                            Image(plant.imageName)
                                                                .resizable()
                                                                .frame(width: 113, height: 144)
                                                            Text(plant.titles)
                                                                .font(.system(size: 14, weight: .semibold, design: .default))
                                                                .foregroundColor(Color.white)
                                                        }
                                                    }
                                                    .padding(.top, 40)

                                                }
                                        
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        .navigationTitle("LeaFit")
                        .navigationBarTitleDisplayMode(.large)
                        .foregroundColor(Color(hex: "428D6D"))
                        .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                HStack {
                                    NavigationLink(destination: InformationView()) {
                                        Image(systemName: "info.circle")
                                            .foregroundStyle(Color(hex: "428D6D"))
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: CameraRulesView()) {
                                        Image(systemName: "camera")
                                            .foregroundStyle(Color(hex: "428D6D"))
                                    }
                                }
                            }
                        }
                        
                        //        .actionSheet(isPresented: $showEditSheet) {
                        //            ActionSheet(
                        //                title: Text("\(selectedCategory?.name ?? "Select a category to edit")"),
                        //                buttons: [
                        //                    .default(Text("Rename")) {
                        //                        if let category = selectedCategory {
                        //                            categoryToRename = category
                        //                            renameCategoryName = category.name
                        //                            showRenameCategory = true
                        //                        }
                        //                    },
                        //                    .destructive(Text("Delete")) {
                        //                        if let category = selectedCategory {
                        //                            categoriesViewModel.deleteCategory(category)
                        //                        }
                        //                    },
                        //                    .cancel()
                        //                ]
                        //            )
                        //        }
                        //        .alert("Rename Category", isPresented: $showRenameCategory) {
                        //            TextField("Category name", text: $renameCategoryName)
                        //                .foregroundColor(.primary)
                        //            Button("Cancel", role: .cancel) {
                        //                renameCategoryName = ""
                        //                categoryToRename = nil
                        //            }
                        //            Button("Save") {
                        //                if let category = categoryToRename,
                        //                   !renameCategoryName.isEmpty,
                        //                   !categoriesViewModel.categoryExists(name: renameCategoryName, excluding: category) {
                        //                    categoriesViewModel.renameCategory(category, newName: renameCategoryName)
                        //                    renameCategoryName = ""
                        //                    categoryToRename = nil
                        //                }
                        //            }
                        //            .disabled(renameCategoryName.isEmpty ||
                        //                     renameCategoryName.count > 24 ||
                        //                     (categoryToRename != nil && categoriesViewModel.categoryExists(name: renameCategoryName, excluding: categoryToRename!)))
                        //        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackgroundColor)
                    .ignoresSafeArea(.all)
                    .scrollContentBackground(.hidden)
                }
                
                
                
            }
        }
        
        
        #Preview {
            MainMenuView()
                .modelContainer(for: PlantCategory.self, inMemory: true)
        }
