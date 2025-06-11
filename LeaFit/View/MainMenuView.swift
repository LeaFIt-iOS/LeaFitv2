//
//  MainMenuView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 10/06/25.
//

import SwiftUI

struct MainMenuView: View {
    
//    private var listTanaman = tanamanTest //test data

    @State var searchPlaceholder = ""
    
    var body: some View {
        NavigationView {
                List {
//                    ForEach (tanamanNya, id: \.self) {
//                        country in
//                        HStack {
//                            Text (country)
//                            Spacer()
//                        }
//                        .padding()
//                    } // test list
                }
            .searchable(text: $searchPlaceholder)
            .navigationBarTitle("LeaFit")
            .navigationBarItems(trailing: EditButton())
            .foregroundColor(Color(hex: "428D6D"))
        }
    }
    
//    var tanamanNya: [String] {
//        let lctanamanNya = listTanaman.map {$0.lowercased()}
//        
//        return searchPlaceholder == "" ? lctanamanNya : lctanamanNya.filter {$0.contains(searchPlaceholder.lowercased())}
//    } // buat test data aja
}



#Preview {
    MainMenuView()
}
