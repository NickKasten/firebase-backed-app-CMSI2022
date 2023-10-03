/**
 * AuthenticationViewController is a SwiftUI “wrapper” around the view controller object
 * provided by FirebaseUI. The mechanism shown here is actually pretty standardized
 * and can be use to “SwiftUI-ize” any other code that is implemented as a view
 * conroller rather than as a SwiftUI View.
 *
 * Some useful links for this approach:
 * - https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit
 * - https://www.hackingwithswift.com/books/ios-swiftui/wrapping-a-uiviewcontroller-in-a-swiftui-view
 */
import SwiftUI
import UIKit

import FirebaseAuthUI

struct AuthenticationViewController: UIViewControllerRepresentable {
    var authUI: FUIAuth
    
    func makeUIViewController(context: Context) -> UINavigationController {
        // We choose to fail loudly here—if we don’t get a view controller successfully,
        // then something is wrong with our overall configuration and we won’t want to
        // continue anyway.
        return authUI.authViewController()
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // We don’t do any updates so we leave this blank.
    }
}
