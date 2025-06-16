//
//  LeaFitApp.swift
//  LeaFit
//
//  Created by FWZ on 09/06/25.
//

import SwiftUI
import SwiftData

@main
struct LeaFitApp: App {
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(hex: "428D6D")
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: "428D6D")]
        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.configureWithOpaqueBackground()
        toolbarAppearance.backgroundColor = UIColor(hex: "BEDCBA")
        UIToolbar.appearance().standardAppearance = toolbarAppearance
        UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(for: [PlantCategory.self, Pot.self, Leaf.self, Diagnose.self])
    }
}
