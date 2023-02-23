//
//  PreviousSprintnameDetailsView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 10.01.23.
//

import SwiftUI

struct PreviousSprintnameDetailsView: View {
    var name: String
    var date: Date
    var receivedVotes: Int16
    var totalVotes: Int16
    var roundsOfVotes: Int16
    var body: some View {
        VStack{
            Text("\(name)")
                .bold()
                .font(.largeTitle)
                .foregroundColor(.green)
                .accessibilityIdentifier("SprintName")
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.red)
                    .font(.title3)
                    .accessibilityIdentifier("Img_Calendar")
                Text("\(date.formatted())")
                    .font(.title3)
            }
            if (roundsOfVotes == 1) {
                Text("Won with \(receivedVotes) out of \(totalVotes) votes\n after the first vote")
                    .multilineTextAlignment(.center)
            }
            if (roundsOfVotes > 1) {
                Text("Won with \(receivedVotes) out of \(totalVotes) votes\n after \(roundsOfVotes) rounds of voting")
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#if !TESTING
struct PreviousSprintnameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousSprintnameDetailsView(name: "Tester", date: Date(), receivedVotes: Int16(5), totalVotes: Int16(7), roundsOfVotes: Int16(2))
    }
}
#endif
