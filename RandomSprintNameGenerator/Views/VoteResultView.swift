//
//  VoteResultView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI
import CoreData

struct VoteResultView: View {
    
    @ObservedObject var randomWordFetcher: RandomWordFetcher
    @State var chosenSprintName: String
    @Binding var showingVotingResult: Bool
    @Binding var castedVotes: Int
    @Binding var roundsOfVotes: Int
    @Binding var voteHasFinished: Bool
    var voteHasOneWinner: Bool
    var topVoteCount: Int
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
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
                    let newEntry = SprintNames (context: moc)
                    newEntry.id = UUID()
                    newEntry.name = chosenSprintName
                    newEntry.dateOfVote = Date()
                    newEntry.receivedVotes = Int16(topVoteCount)
                    newEntry.totalVotes = Int16(castedVotes)
                    newEntry.roundsOfVotes = Int16(roundsOfVotes)
                    
                    try? moc.save()
                    voteHasFinished = true
                    showingVotingResult = false
                }, label: {
                    Text("Save & Exit")
                        .font(.title2)
                })
                .accessibilityIdentifier("Button_SaveAndExit")
            }
            .interactiveDismissDisabled()
        }
        if (!voteHasOneWinner) {
            VStack {
                Text("The Vote has been tied.")
                    .font(.title2)
                Text("")
                Button(action: {
                    randomWordFetcher.prepForTiebreaker(topVoteCount: topVoteCount)
                    roundsOfVotes += 1
                    castedVotes = 0
                    dismiss()
                }, label: {
                    Text("Tiebreaker vote")
                        .font(.title2)
                })
                .accessibilityIdentifier("Button_TiebreakerVote")
                .interactiveDismissDisabled()
                
            }
        }
    }
}

#if !TESTING
struct VoteResultView_Previews: PreviewProvider {
    static var previews: some View {
        VoteResultView(randomWordFetcher: RandomWordFetcher(), chosenSprintName: "Testwinner", showingVotingResult: .constant(true), castedVotes: .constant(4), roundsOfVotes: .constant(2), voteHasFinished: .constant(false), voteHasOneWinner: false, topVoteCount: 3)
    }
}
#endif
