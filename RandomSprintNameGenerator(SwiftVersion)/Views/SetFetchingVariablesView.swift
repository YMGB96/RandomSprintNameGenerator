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
    @State var submitDisabled = true
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
            Text("How many possible names would you like to generate? (2-9)")
            TextField("Word amount", text: $randomWordFetcher.wordCount)
                .onReceive(Just(randomWordFetcher.wordCount)) { newValue in
                    let filtered = newValue.filter { "23456789".contains($0) }
                    if filtered != newValue {
                        self.randomWordFetcher.wordCount = filtered
                    }
                    if randomWordFetcher.wordCount.count > 1 {
                        randomWordFetcher.wordCount = String(randomWordFetcher.wordCount.prefix(1))
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
                    if Int(randomWordFetcher.voterAmount) ?? 1 > 1 && randomWordFetcher.wordCount.count > 0 &&
                        randomWordFetcher.firstLetter.count > 0 {
                        self.submitDisabled = false
                    }
                }
            Button(action: {
                if (randomWordFetcher.firstLetter.isEmpty == false && randomWordFetcher.wordCount.isEmpty == false) {
                    randomWordFetcher.getRandomWords(firstLetter: randomWordFetcher.firstLetter, wordCount: randomWordFetcher.wordCount)
                }
                else {
                    print("placeholder Notification")
                }
                }, label: {
                    Text("Submit")
            })
            .disabled(submitDisabled)
        }
    }
}


struct SetFetchingVariablesView_Previews: PreviewProvider {
    static var previews: some View {
        SetFetchingVariablesView()
    }
}
