//
//  TabBarView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var refreshID = UUID()
    
    init() {
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .systemBackground.withAlphaComponent(0.5)
    }
    
    var body: some View {
        TabView {
            
            HomeView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem{Label(AppStrings.homeTitle, systemImage: AppStrings.sysimgHomeTab)}
            
            ModulesView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem{Label(AppStrings.modulesTitle, systemImage: AppStrings.sysimgModTab)}
            
            ToolsView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem{Label(AppStrings.toolsTitle, systemImage: AppStrings.sysimgToolsTab)}
        }
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
