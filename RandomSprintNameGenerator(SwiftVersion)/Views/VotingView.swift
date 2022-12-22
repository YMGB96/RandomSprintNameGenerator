//
//  VotingView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import SwiftUI


struct VotingView: View {
    @State var randomWords: [RandomWordFetcher.RandomWordElement]
    var voterAmount: Int
    var body: some View {
        List{
            ForEach(Array(randomWords.enumerated()), id: \.element) { index, randomWord in
                HStack {
                    Text(randomWord.randomWord)
                    Text("\(randomWord.voteCount) votes")
                    Button(action: {
                        print("voted for \(randomWord.randomWord)")
                        self.randomWords[index].voteCount += 1 //0 placeholder
                        
                    }, label: {
                        Image("ballot")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 60.0, height: 60.0)
                    })
                    .frame(width: 60.0, height: 60.0)
                }
            }
        }
    }
}

struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        let previewWord1 = RandomWordFetcher.RandomWordElement(randomWord: "Eeny", voteCount: 0)
        let previewWord2 = RandomWordFetcher.RandomWordElement(randomWord: "Meeny", voteCount: 0)
        let previewWord3 = RandomWordFetcher.RandomWordElement(randomWord: "Miney", voteCount: 0)
        let previewWord4 = RandomWordFetcher.RandomWordElement(randomWord: "Mo", voteCount: 0)
        VotingView(randomWords: [previewWord1, previewWord2, previewWord3, previewWord4], voterAmount: Int("4") ?? 0)
    }
}
