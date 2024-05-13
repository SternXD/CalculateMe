//
//  CalculateMeApp.swift
//  CalculateMe
//
//  Created by Xavier Stern on 5/13/24.
//

import SwiftUI

@main
struct CalculateMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
