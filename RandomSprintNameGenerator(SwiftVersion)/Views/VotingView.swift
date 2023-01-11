//
//  VotingView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI


struct VotingView: View {
    var firstLetter: String
    var wordCount: String
    var voterAmount: Int
    @State var castedVotes = 0
    @State var showingVotingResult = false
    @StateObject var randomWordFetcher = RandomWordFetcher()
    var body: some View {
        List{
            HStack {
                Text("\(castedVotes) out of \(voterAmount) votes have been cast")
                Button(action: {
                    if (castedVotes == voterAmount) {
                        self.showingVotingResult = true
                    }
                }, label: {
                    Text("Submit")
                }
                )
            }
            ForEach(Array(randomWordFetcher.randomWords.enumerated()), id: \.element) { index, randomWord in
                HStack {
                    
                    Text(randomWord.randomWord)
                    Text("\(randomWord.voteCount) votes")
                    Button(action: {
                        if (castedVotes != voterAmount) {
                            randomWordFetcher.randomWords[index].voteCount += 1
                            castedVotes += 1
                        }
                    }, label: {
                        Image("ballot")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 60.0, height: 60.0)
                    })
                    .frame(width: 60.0, height: 60.0)
                }
            }
        }
        .popover(isPresented: $showingVotingResult) {
            //need to check if multiples exist
            let mostVotedRandomName = randomWordFetcher.randomWords.max(by: { $0.voteCount < $1.voteCount } )
            if (randomWordFetcher.randomWords.filter { $0.voteCount == mostVotedRandomName?.voteCount }.count == 1) {
                let winningName = mostVotedRandomName!.randomWord
                VoteResultView(chosenSprintName: winningName)
            } else if (randomWordFetcher.randomWords.filter { $0.voteCount == mostVotedRandomName?.voteCount }.count > 1) {
                Text("Placeholder for tiebreaker, with the options for a second round of votes between the tied names or by a randomized selection")
            }
        }
        .onAppear() {
            randomWordFetcher.getRandomWords(firstLetter: firstLetter, wordCount: wordCount)
        }
    }
}


struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView(firstLetter: "a", wordCount: "5",  voterAmount: Int("4") ?? 0)
    }
}
