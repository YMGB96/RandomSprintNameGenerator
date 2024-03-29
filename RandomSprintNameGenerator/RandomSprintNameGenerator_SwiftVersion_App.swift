//
//  RandomSprintNameGenerator_SwiftVersion_App.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

@main
struct RandomSprintNameGenerator_SwiftVersion_App: App {
    private static var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, Self.dataController.container.viewContext)
        }
    }
}
