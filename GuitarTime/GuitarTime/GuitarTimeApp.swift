//
//  GuitarTimeApp.swift
//  GuitarTime
//
//  Created by Caroline Viana on 23/08/23.
//

import SwiftUI

@main
struct GuitarTimeApp: App {
    @StateObject var persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
