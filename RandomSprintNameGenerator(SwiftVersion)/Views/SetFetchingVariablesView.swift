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
    @State var submitDisabled = false
    @State var showingInputMissingAlert = false
    var body: some View {
        NavigationView {
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
                Button(action: {
                    if randomWordFetcher.voterAmount.count > 0 && randomWordFetcher.wordCount.count > 0 &&
                        randomWordFetcher.firstLetter.count > 0 {
                        self.submitDisabled = true
                        randomWordFetcher.getRandomWords(firstLetter:randomWordFetcher.firstLetter, wordCount: randomWordFetcher.wordCount)
                    } else {
                        showingInputMissingAlert = true
                    }
                }, label: {
                    Text("Submit")
                })
                .disabled(submitDisabled)
                .alert("Please fill in all fields", isPresented: $showingInputMissingAlert) {
                    Button("OK", role: .cancel) { }
                }
                NavigationLink(destination: VotingView(randomWords:randomWordFetcher.randomWords, voterAmount: Int(randomWordFetcher.voterAmount) ?? 5)){
                    Text("Vote")
                }
                .disabled(randomWordFetcher.namesHaveBeenFetched == false)
            }
        }
    }
}



struct SetFetchingVariablesView_Previews: PreviewProvider {
    static var previews: some View {
        SetFetchingVariablesView()
    }
}
