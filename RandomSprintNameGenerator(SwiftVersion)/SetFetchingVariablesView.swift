//
//  SetFetchingVariablesView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

struct SetFetchingVariablesView: View {
    
    @StateObject var randomWordFetcher = RandomWordFetcher()
    
    var body: some View {
        Form {
            Text("Please enter the first letter for your new sprint name:")
            TextField("First letter", text: $randomWordFetcher.firstLetter)
            Text("How many possible names would you like to generate? (up to <menge noch zu bestimmen>)")
            TextField("Word amount", text: $randomWordFetcher.wordCount)
        }
        .onSubmit {
            randomWordFetcher.getRandomWords(firstLetter: randomWordFetcher.firstLetter, wordCount: randomWordFetcher.wordCount)
        }
    }
}

struct SetFetchingVariablesView_Previews: PreviewProvider {
    static var previews: some View {
        SetFetchingVariablesView()
    }
}
