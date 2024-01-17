//
//  otus_12App.swift
//  otus_12
//
//  Created by Титов Кирилл Иванович on 17.01.2024.
//

import SwiftUI

@main
struct otus_12App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}
