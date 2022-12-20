//
//  VotingView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

struct VotingView: View {
    let randomWords: [String]
    var body: some View {
        Text("Here be elections")
    }
}

struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView(randomWords: ["Scooby-dooby-doo", "where are you?", "we got some work", "to do now"])
    }
}
