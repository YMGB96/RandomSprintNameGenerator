//
//  PreviousSprintnamesListView.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 10.01.23.
//

import SwiftUI

struct PreviousSprintnamesListView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateOfVote, order: .reverse)]) var sprintNames: FetchedResults<SprintNames>
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        List{
            ForEach (sprintNames) { sprintName in
                NavigationLink(destination: PreviousSprintnameDetailsView(name: sprintName.name ?? "no data", date: sprintName.dateOfVote ?? Date(), receivedVotes: sprintName.receivedVotes , totalVotes: sprintName.totalVotes, roundsOfVotes: sprintName.roundsOfVotes )) {
                    VStack{
                        Text(sprintName.name ?? "no data")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.green)
                        HStack{
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                            Text("\(sprintName.dateOfVote!.formatted(.dateTime.day().month().year()))")
                        }
                    }
                }
            }
            .onDelete(perform: deleteSprintName)
        }
    }
    func deleteSprintName (at offsets: IndexSet) {
        for offset in offsets {
            let list = sprintNames[offset]
            moc.delete(list)
        }
        try? moc.save()
    }
}

struct PreviousSprintnamesListView_Previews: PreviewProvider {
    static let dataController: DataController = {
        let retVal = DataController(isInMemory: true)
        let context = retVal.container.viewContext
        for index in 0..<5 {
            let sprintName = SprintNames(context: context)
            sprintName.id = UUID()
            sprintName.dateOfVote = Date()
            sprintName.name = "Preview name \(index)"
            sprintName.receivedVotes = Int16(2)
            sprintName.totalVotes = Int16(3)
        }
        return retVal
    }()

    static var previews: some View {
        let context = dataController.container.viewContext
        PreviousSprintnamesListView()
            .environment(\.managedObjectContext, context)
    }
}
