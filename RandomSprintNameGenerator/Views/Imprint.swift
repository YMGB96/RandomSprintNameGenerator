//
//  Imprint.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 20.12.22.
//

import SwiftUI

struct Imprint: View {
    var body: some View {
        List{
            Text("API used for the random names:\nhttps://random-word-form.herokuapp.com")
            Text("Ballot picture from: \nhttps://pixabay.com/vectors/ballot-election-vote-1294935/\nfree to use under the pixabay license \nhttps://pixabay.com/service/terms/")
        }
    }
}

#if !TESTING
struct Imprint_Previews: PreviewProvider {
    static var previews: some View {
        Imprint()
    }
}
#endif
