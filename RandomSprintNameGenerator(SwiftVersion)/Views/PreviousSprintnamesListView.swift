//
//  PreviousSprintnamesListView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 10.01.23.
//

import SwiftUI

struct PreviousSprintnamesListView: View {
    var body: some View {
        NavigationView {
            NavigationLink("Placeholder", destination: PreviousSprintnameDetailsView())
        }
    }
}

struct PreviousSprintnamesListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousSprintnamesListView()
    }
}
