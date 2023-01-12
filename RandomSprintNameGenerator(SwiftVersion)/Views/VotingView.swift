//
//  VotingView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI


struct VotingView: View {
    var voterAmount: Int
    @State var castedVotes = 0
    @State var showingVotingResult = false
    @ObservedObject var randomWordFetcher: RandomWordFetcher
    var body: some View {
        List{
            HStack {
                Text("\(castedVotes) out of \(voterAmount) votes have been cast")
                Button(action: {
                    self.showingVotingResult = true
                }, label: {
                    Image(systemName: "checkmark.square.fill")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .frame(width: 25.0, height: 25.0)
                        
                }
                )
                .disabled(castedVotes != voterAmount)
            }
            
            if (randomWordFetcher.randomWords.count == 0) {
                ProgressView()
                    .frame(width: 400.0)
                    .scaleEffect(1.5, anchor: .center)
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
                            .frame(width: 30.0, height: 30.0)
                    })
                }
            }
        }
        .sheet(isPresented: $showingVotingResult) {
            let mostVotedRandomName = randomWordFetcher.randomWords.max(by: { $0.voteCount < $1.voteCount } )
            if (randomWordFetcher.randomWords.filter { $0.voteCount == mostVotedRandomName?.voteCount }.count == 1) {
                let winningName = mostVotedRandomName!.randomWord
                VoteResultView(randomWordFetcher: randomWordFetcher, chosenSprintName: winningName, showingVotingResult: $showingVotingResult, castedVotes: $castedVotes, voteHasOneWinner: true, topVoteCount: mostVotedRandomName!.voteCount)
            } else if (randomWordFetcher.randomWords.filter { $0.voteCount == mostVotedRandomName?.voteCount }.count > 1) {
                VoteResultView(randomWordFetcher: randomWordFetcher, chosenSprintName: "there is more than one", showingVotingResult: $showingVotingResult,castedVotes: $castedVotes, voteHasOneWinner: false, topVoteCount: mostVotedRandomName!.voteCount)
            }
        }
        .onAppear() {
            if (randomWordFetcher.randomWords.count == 0) {
                randomWordFetcher.getRandomWords(firstLetter: randomWordFetcher.firstLetter, wordCount: randomWordFetcher.wordCount)
            }
        }
    }
}


struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView(voterAmount: Int("5") ?? 0,randomWordFetcher: RandomWordFetcher())
    }
}
