//
//  Persistent.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/22.
//

import SwiftUI
import CoreData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Checkpoint_4App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            LogInView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .onAppear {
//                    // Reset Core Data when the app launches
//                    persistenceController.resetPersistentStore()
//                }
        }
    }
}
