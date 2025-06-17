import SwiftUI
import SwiftData

struct MainMenuView: View {
    @StateObject private var mainMenuViewModel = MainMenuViewModel()
    
    @State private var selectedCategory: PlantCategory?
    @State private var isEditMode = false
    @Environment(\.modelContext) private var modelContext
    
    var groupedCategories: [[PlantCategory]] {
        stride(from: 0, to: mainMenuViewModel.allCategories.count, by: 3).map {
            Array(mainMenuViewModel.allCategories[$0..<min($0 + 3, mainMenuViewModel.allCategories.count)])
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    Image("img-framejendela")
                        .padding(.top, 70)
                    VStack(spacing: -80) {
                        ForEach(Array(groupedCategories.enumerated()), id: \.offset) { _, group in
                            ZStack {
                                Image("img-rakpot")
                                    .padding(.top, 180)
                                
                                HStack(spacing: 2) {
                                    ForEach(group, id: \.id) { category in
                                        let isAvailable = category.title == "Aloe Vera" // Customize logic
                                        
                                        NavigationLink(
                                            destination: isAvailable
                                            ? AnyView(PlantListView(pots: category.pots, title: category.title))
                                            : AnyView(UnavailablePotView(pots: category.pots, title: category.title))
                                        ) {
                                            VStack(spacing: 0) {
                                                Image(category.imageName)
                                                    .resizable()
                                                    .frame(width: 113, height: 144)
                                                Text(category.title)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(.top, 40)
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
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackgroundColor)
            .ignoresSafeArea(.all)
            .scrollContentBackground(.hidden)
            .onAppear {
                mainMenuViewModel.setModelContext(modelContext)
            }
        }
    }
}


#Preview {
    MainMenuView()
        .modelContainer(for: PlantCategory.self, inMemory: true)
}
