//
//  KastenSpellsBlogApp.swift
//  KastenSpellsBlog
//
//  Created by Nick Kasten on 4/10/23.
//

import SwiftUI

@main
struct KastenSpellsBlogApp: App {
    @UIApplicationDelegateAdaptor(KastenSpellsBlogAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(KastenSpellsBlogAuth())
                .environmentObject(KastenSpellsBlogArticle())
        }
    }
}
