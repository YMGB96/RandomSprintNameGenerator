//
//  SetFetchingVariablesView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI
import Combine

struct SetFetchingVariablesView: View {
    
    @StateObject var randomWordFetcher = RandomWordFetcher()
    var body: some View {
            List {
                Text("Please enter the first letter for your new sprint name:")
                TextField("First letter", text: $randomWordFetcher.firstLetter)
                    .onReceive(Just(randomWordFetcher.firstLetter)) { newValue in
                        let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0) }
                        if filtered != newValue {
                            self.randomWordFetcher.firstLetter = filtered
                        }
                        if randomWordFetcher.firstLetter.count > 1 {
                            randomWordFetcher.firstLetter = String(randomWordFetcher.firstLetter.prefix(1))
                        }
                    }
                Text("How many possible names would you like to generate? (2-10)")
                TextField("Word amount", text: $randomWordFetcher.wordCount)
                    .onReceive(Just(randomWordFetcher.wordCount)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.randomWordFetcher.wordCount = filtered
                        }
                        if randomWordFetcher.wordCount.count > 2 {
                            randomWordFetcher.wordCount = String(randomWordFetcher.wordCount.prefix(2))
                        }
                        if Int(randomWordFetcher.wordCount) ?? 8 > 10 {
                            randomWordFetcher.wordCount = "10"
                        }
                    }
                Text("How many people are voting?")
                TextField("Voter amount", text: $randomWordFetcher.voterAmount)
                    .onReceive(Just(randomWordFetcher.voterAmount)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.randomWordFetcher.voterAmount = filtered
                        }
                        if randomWordFetcher.voterAmount.count > 3 {
                            randomWordFetcher.voterAmount = String(randomWordFetcher.voterAmount.prefix(3))
                        }
                    }
                NavigationLink(destination: VotingView(firstLetter: randomWordFetcher.firstLetter, wordCount: randomWordFetcher.wordCount, voterAmount: Int(randomWordFetcher.voterAmount) ?? 5)){
                    Text("Vote")
                }
                .disabled(!randomWordFetcher.isReadyToFetch)
            }
            .toolbar{
                ToolbarItem(placement: .automatic) {Text("test")}
            }
        }
}



struct SetFetchingVariablesView_Previews: PreviewProvider {
    static var previews: some View {
        SetFetchingVariablesView()
    }
}
