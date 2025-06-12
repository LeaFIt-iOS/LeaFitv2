//
//  SamplePreview.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 11/06/25.
//

import SwiftUI
import Foundation

struct SamplePreview : View {
    var body: some View {
        Text("Hello, World!")
        TabView {
            NavigationStack {
                List {
                    Text("Home Content")
                        .frame(height: 20000)
                }
                .navigationTitle("Home Title")
            }
            .tabItem {
                Label("Home", systemImage: "house")
                
            }
            .toolbarBackground(

                // 1
                Color.yellow,
                // 2
                for: .tabBar)
            
            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            Text("Notification")
                .tabItem {
                    Label("Notification", systemImage: "bell")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        
    }
}

#Preview {
    SamplePreview()
}
