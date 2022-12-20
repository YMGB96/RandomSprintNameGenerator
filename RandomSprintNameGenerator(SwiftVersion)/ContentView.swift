//
//  ContentView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

struct ContentView: View {
    
    var votingTime = false
    @State private var showingPopover = false
    var body: some View {
        Button("Set Variables Placeholder") {
            showingPopover = true
        }
        .popover(isPresented: $showingPopover) {
            SetFetchingVariablesView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
