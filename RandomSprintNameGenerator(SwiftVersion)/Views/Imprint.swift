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
            Text("Placeholder for the following:")
            Text("Ballot picture from: \nhttps://pixabay.com/vectors/ballot-election-vote-1294935/, free to use under the pixabay license \nhttps://pixabay.com/service/terms/")
            Text("API used for the random words: \nhttps://random-word-form.herokuapp.com")
        }
    }
}
//placeholder: https://pixabay.com/vectors/ballot-election-vote-1294935/ for the ballot picture, free to use under the pixabay license https://pixabay.com/service/terms/
struct Imprint_Previews: PreviewProvider {
    static var previews: some View {
        Imprint()
    }
}
