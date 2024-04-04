//
//  DataController.swift
//  People
//
//  Created by USER on 2024-03-25.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PersonModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved! :) ")
        } catch {
            print("Data not saved! :( ")
        }
    }
    
    func addPerson(firstName: String, lastName: String, birthday: Date, notes: String, avatarData: Data, context: NSManagedObjectContext) {
        let person = Person(context: context)
        person.id = UUID()
        person.firstName = firstName
        person.lastName = lastName
        person.birthday = birthday
        person.notes = notes
        person.avatarData = avatarData
        save(context: context)
    }
    
    func editPerson(person: Person, firstName: String, lastName: String, birthday: Date, notes: String, avatarData: Data, context: NSManagedObjectContext) {
        person.firstName = firstName
        person.lastName = lastName
        person.birthday = birthday
        person.notes = notes
        person.avatarData = avatarData
        save(context: context)
    }
}
