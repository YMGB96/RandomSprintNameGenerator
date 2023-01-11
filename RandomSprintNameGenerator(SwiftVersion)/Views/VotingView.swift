//
//  VotingView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI


struct VotingView: View {
    @State var randomWords: [RandomWordFetcher.RandomWordElement]
    var voterAmount: Int
    @State var castedVotes = 0
    @State var showingVotingResult = false
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
            ForEach(Array(randomWords.enumerated()), id: \.element) { index, randomWord in
                HStack {
                    
                    Text(randomWord.randomWord)
                    Text("\(randomWord.voteCount) votes")
                    Button(action: {
                        if (castedVotes != voterAmount) {
                            self.randomWords[index].voteCount += 1
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
            let mostVotedRandomName = randomWords.max(by: { $0.voteCount < $1.voteCount } )
            if (randomWords.filter { $0.voteCount == mostVotedRandomName?.voteCount }.count == 1) {
                let winningName = mostVotedRandomName!.randomWord
                VoteResultView(chosenSprintName: winningName)
            } else if (randomWords.filter { $0.voteCount == mostVotedRandomName?.voteCount }.count > 1) {
                Text("Placeholder for tiebreaker, with the options for a second round of votes between the tied names or by a randomized selection")
            }
        }
    }
}


struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        let previewWord1 = RandomWordFetcher.RandomWordElement(randomWord: "Eeny", voteCount: 0)
        let previewWord2 = RandomWordFetcher.RandomWordElement(randomWord: "Meeny", voteCount: 0)
        let previewWord3 = RandomWordFetcher.RandomWordElement(randomWord: "Miney", voteCount: 0)
        let previewWord4 = RandomWordFetcher.RandomWordElement(randomWord: "Mo", voteCount: 0)
        let previewWord5 = RandomWordFetcher.RandomWordElement(randomWord: "I'm", voteCount: 0)
        let previewWord6 = RandomWordFetcher.RandomWordElement(randomWord: "running", voteCount: 0)
        let previewWord7 = RandomWordFetcher.RandomWordElement(randomWord: "out", voteCount: 0)
        let previewWord8 = RandomWordFetcher.RandomWordElement(randomWord: "of", voteCount: 0)
        let previewWord9 = RandomWordFetcher.RandomWordElement(randomWord: "words", voteCount: 0)
        VotingView(randomWords: [previewWord1, previewWord2, previewWord3, previewWord4, previewWord5, previewWord6,
                                 previewWord7, previewWord8, previewWord9], voterAmount: Int("4") ?? 0)
    }
}
