//
//  VoteResultView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

struct VoteResultView: View {
    @ObservedObject var randomWordFetcher: RandomWordFetcher
    @State var chosenSprintName: String
    @Binding var showingVotingResult: Bool
    @Binding var castedVotes: Int
    var voteHasOneWinner: Bool
    var topVoteCount: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if (voteHasOneWinner) {
            VStack{
                Text("The chosen Sprintname is:")
                    .font(.title2)
                Text("\(chosenSprintName)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.green)
                Text("\n")
                Button(action: {
                    showingVotingResult = false
                }, label: {
                    Text("Save & Exit")
                        .font(.title2)
                })
                Text("saving to be added soon")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        if (!voteHasOneWinner) {
            VStack {
                Text("The Vote has been tied.")
                    .font(.title2)
                Text("")
                Button(action: {
                    randomWordFetcher.prepForTiebreaker(topVoteCount: topVoteCount)
                    castedVotes = 0
                    dismiss()
                }, label: {
                    Text("Tiebreaker vote")
                        .font(.title2)
                })
                
            }
        }
    }
}
struct VoteResultView_Previews: PreviewProvider {
    static var previews: some View {
        VoteResultView(randomWordFetcher: RandomWordFetcher(), chosenSprintName: "Testwinner", showingVotingResult: .constant(true), castedVotes: .constant(4), voteHasOneWinner: false, topVoteCount: 3)
    }
}
