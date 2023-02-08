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
                .font(.title3)
            TextField("First letter", text: $randomWordFetcher.firstLetter)
                .font(.title3)
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
                .font(.title3)
            TextField("Word amount", text: $randomWordFetcher.wordCount)
                .font(.title3)
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
                .font(.title3)
            TextField("Voter amount", text: $randomWordFetcher.voterAmount)
                .font(.title3)
                .onReceive(Just(randomWordFetcher.voterAmount)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.randomWordFetcher.voterAmount = filtered
                    }
                    if randomWordFetcher.voterAmount.count > 3 {
                        randomWordFetcher.voterAmount = String(randomWordFetcher.voterAmount.prefix(3))
                    }
                }
            NavigationLink(destination: VotingView(voterAmount: Int(randomWordFetcher.voterAmount) ?? 5,roundsOfVotes: 1, randomWordFetcher: randomWordFetcher)){
                Text("Vote")
                    .font(.title3)
            }
            .disabled(!randomWordFetcher.isReadyToFetch)
        }
        .onAppear() {
            randomWordFetcher.randomWords.removeAll()
        }
    }
}

struct SetFetchingVariablesView_Previews: PreviewProvider {
    static var previews: some View {
        SetFetchingVariablesView()
    }
}
