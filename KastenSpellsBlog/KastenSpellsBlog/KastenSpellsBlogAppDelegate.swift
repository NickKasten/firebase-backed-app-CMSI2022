/**
 * BareBonesBlogAppDelegate sets up the Firebase SDK for communication with your
 * project. It does this via the UIApplicationDelegate protocol, which provides
 * a mechanism for executing application-level code that isn’t covered directly by
 * SwiftUI. The Firebase documentation uses this mechanism to get your app going
 * with Firebase. Take a look at BareBonesBlogApp to see how this “delegate” is
 * connected to the SwiftUI app itself.
 *
 * For a few more details, look at this brief item from Hacking with Swift:
 *     https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app
 */
import Foundation
import UIKit

// As a personal preference, I tend to put third-party library imports after the
// first-party iOS ones just so I know who’s responsible for what.
import Firebase

class KastenSpellsBlogAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    private func applicationWillTerminate(_ application: UIApplication) throws {
        try KastenSpellsBlogAuth().signOut()
    }
}
