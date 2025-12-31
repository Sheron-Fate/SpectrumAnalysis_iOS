//
//  SpectrumAnalysisiOSApp.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import SwiftUI

@main
struct SpectrumAnalysisiOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Главный экран приложения с TabView для навигации
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }

            PigmentsList()
                .tabItem {
                    Label("Пигменты", systemImage: "paintpalette.fill")
                }
        }
        .accentColor(.appSecondary)
    }
}
