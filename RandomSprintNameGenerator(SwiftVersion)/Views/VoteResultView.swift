//
//  VoteResultView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI

struct VoteResultView: View {
    @State var chosenSprintName: String
    var body: some View {
        Text("The chosen Sprintname is \(chosenSprintName)!\n(in the future, you can save the result and there will actually be something resembling desing")
        
    }
}

struct VoteResultView_Previews: PreviewProvider {
    static var previews: some View {
        let previewWinner = "Tester"
        VoteResultView(chosenSprintName: previewWinner)
    }
}
