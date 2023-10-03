/**
 * BareBonesBlogAuth is an object that interacts with Firebase Authentication, allowing
 * it to keep track of user activities relating to login. It publishes its `user` variable
 * so that SwiftUI views will update when this variable changes.
 */
import Foundation

import FirebaseAuthUI
import FirebaseEmailAuthUI

// this is modeling the service (firebase)
class KastenSpellsBlogAuth: NSObject, ObservableObject, FUIAuthDelegate {
    // bridge to the Firebase authentication
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()

    // Array of our authentication providers
    // Multiple providers can be supported! See: https://firebase.google.com/docs/auth/ios/firebaseui
    let providers: [FUIAuthProvider] = [
        FUIEmailAuth() // must correspond with your project
    ]

    // this is allowing your app to know about whether there is a user or not
    @Published var user: User?

    /**
     * You might not have overriden a constructor in Swift before...well, here it is.
     */
    override init() {
        super.init()

        // Note that authUI is marked as _optional_. If things don’t appear to work
        // as expected, check to see that you actually _got_ an authUI object from
        // the Firebase library.
        authUI?.delegate = self
        authUI?.providers = providers
    }

    /**
     * In another case of the documentation being somewhat behind the latest libraries,
     * this delegate method:
     *
     *     func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?)
     *
     * …has been deprecated in favor of the one below.
     */
    
    // from the documentation at https://firebase.google.com/docs/auth
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let actualResult = authDataResult {
            user = actualResult.user
            if let user {
                if let email = user.email {
                    print(email)
                }
            }
        }
    }

    func signOut() throws {
        //
        try authUI?.signOut()

        // If we get past the logout attempt, we can safely clear the user.
        user = nil
    }
}
