//
//  ContentView.swift
//  People
//
//  Created by USER on 2024-03-25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.birthday, order: .reverse)]) var people: FetchedResults<Person>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(people) { person in
                        NavigationLink(destination: EditPersonView(person: person)) {
                            HStack {
                                HStack(alignment: .center, spacing: 6) {
                                    HStack {
                                        Text(person.firstName!).bold().lineLimit(2).minimumScaleFactor(0.5)
                                        Text(person.lastName!).bold().lineLimit(2).minimumScaleFactor(0.5)
                                        
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Turning \(getTurningAge(birthday: person.birthday!))")
                                        Text("\(daysUntil(birthday: person.birthday!))")
                                    }
                                    
                                }
                            }
                        }.navigationBarTitleDisplayMode(.automatic)
                    }.onDelete(perform: deletePerson)
                }.listStyle(.plain)
            }.navigationTitle("People")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddPersonView()) {
                            Label("Add Person", systemImage: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
    }
    
    private func deletePerson(offsets: IndexSet) {
        withAnimation {
            offsets.map { people[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
