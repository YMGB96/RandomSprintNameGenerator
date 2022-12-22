//
//  ContentView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var randomWordFetcher = RandomWordFetcher()
    
    var body: some View {
        NavigationView{
            NavigationLink(destination: SetFetchingVariablesView()) {
                Text("Vote")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
