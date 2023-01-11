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
            List{
                NavigationLink("Vote on a new Sprint name", destination: SetFetchingVariablesView())
                    .font(.title)
                    .bold()
                NavigationLink("Previous Sprintnames", destination: PreviousSprintnamesListView())
                    .font(.title)
                    .bold()
                NavigationLink("Imprint", destination: Imprint())
                    .font(.title)
                    .bold()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Random")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .bold()
                            .padding(.top)
                            
                        Text("Sprintname Generator")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .bold()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}