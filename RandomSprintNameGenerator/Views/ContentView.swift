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
                    .accessibilityIdentifier("Nav_SetFetchingVariablesView")
                NavigationLink("Previous Sprintnames", destination: PreviousSprintnamesListView())
                    .font(.title)
                    .bold()
                    .accessibilityIdentifier("Nav_PreviousSprintnamesListView")
                NavigationLink("Imprint", destination: Imprint())
                    .font(.title)
                    .bold()
                    .accessibilityIdentifier("Nav_Imprint")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Sprintname Generator")
                        .multilineTextAlignment(.center)
                        .bold()
                        .font(.title2)
                }
            }
        }
    }
}

#if !TESTING
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
