//
//  lab02App.swift
//  lab02
//
//  Created by Lucely Mendoza on 1/10/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LAB02App: App {
    @State var isLoggedin: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isLoggedin {
                    ContentView(isLoggedin: $isLoggedin)
                } else {
                    LoginView(isLoggedin: $isLoggedin)
                }
            }
        }
    }
}



