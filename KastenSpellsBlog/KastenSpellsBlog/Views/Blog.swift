/**
 * The Blog view provides a top-level wrapper to check whether things are configured OK.
 */
import SwiftUI

struct Blog: View {
    @EnvironmentObject var auth: KastenSpellsBlogAuth
    @State var requestLogin = false
    
    var body: some View {
        if let authUI = auth.authUI {
            ArticlesList(requestLogin:  $requestLogin, articles: [])
                .sheet(isPresented: $requestLogin) {
                    AuthenticationViewController(authUI: authUI)
                }
        } else {
            VStack {
                Text("Sorry, looks like we aren’t set up right!")
                    .padding()
                
                Text("Please contact this app’s developer for assistance.")
                    .padding()
            }
        }
    }
}

struct Blog_Previews: PreviewProvider {
    static var previews: some View {
        Blog().environmentObject(KastenSpellsBlogAuth())
    }
}
