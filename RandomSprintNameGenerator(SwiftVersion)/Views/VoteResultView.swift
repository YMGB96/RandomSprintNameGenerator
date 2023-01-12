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
                Text("The chosen Sprintname is \(chosenSprintName)!\n(in the future, you can save the result and there will actually be something resembling desing")
                Button(action: {
                    showingVotingResult = false
                }, label: {
                    Text("Dismiss")
                })
            }
        }
        if (!voteHasOneWinner) {
            VStack {
                Text("The Vote has been tied.")
                Button(action: {
                    randomWordFetcher.prepForTiebreaker(topVoteCount: topVoteCount)
                    castedVotes = 0
                    dismiss()
                }, label: {
                    Text("Re-Vote")
                })
                
            }
        }
    }
}
//struct VoteResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        VoteResultView(randomWordFetcher: RandomWordFetcher(), chosenSprintName:"Testwinner", voteHasOneWinner: true, topVoteCount: 4)
//    }
//}
