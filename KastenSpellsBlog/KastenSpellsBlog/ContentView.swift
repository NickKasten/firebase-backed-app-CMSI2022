//
//  ContentView.swift
//  KastenSpellsBlog
//
//  Created by Nick Kasten on 4/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Blog()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(KastenSpellsBlogAuth())
    }
}
