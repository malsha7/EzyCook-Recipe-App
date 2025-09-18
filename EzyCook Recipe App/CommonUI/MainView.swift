//
//  MainView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-18.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                HomeView(selectedTab: $selectedTab)
            case 1:
                SelectToolsView(selectedTab: $selectedTab)
            case 2:
                MyRecipesView(selectedTab: $selectedTab)
            case 3:
                FavoritesListView(selectedTab: $selectedTab)
            case 4:
                SettingsView(selectedTab: $selectedTab)
            default:
                HomeView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainView()
}
