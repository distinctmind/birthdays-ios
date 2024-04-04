//
//  PeopleApp.swift
//  People
//
//  Created by USER on 2024-03-25.
//

import SwiftUI

@main
struct BirthdaysApp: App {
    @State private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
