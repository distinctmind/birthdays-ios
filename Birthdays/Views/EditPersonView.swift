//
//  EditPersonView.swift
//  People
//
//  Created by USER on 2024-03-25.
//

import SwiftUI
import PhotosUI

struct EditPersonView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var person: FetchedResults<Person>.Element
    var dateRange = Date()
    
    @StateObject var viewModel = PersonViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthday = Date()
    @State private var daysUntil = ""
    @State private var notes = ""
    @State private var isEditing = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
            VStack(alignment: .leading) {
                PhotosPicker(selection: $viewModel.selectedAvatar) {
                    if let avatar = viewModel.avatar {
                        Image(uiImage: avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.horizontal, 25)
                            .padding(.vertical, 10)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color(.systemGray))
                            .padding(.horizontal, 25)
                            .padding(.vertical, 10)
                    }
                }
                .onAppear {
                    viewModel.avatar = UIImage(data: person.avatarData ?? Data())
                }
                Form {
                    Section(header: Text("Basic Info")) {
                        TextField("\(person.firstName!)", text: $firstName)
                        TextField("\(person.lastName == "" ? "Last Name" : person.lastName!)", text: $lastName)
                        DatePicker("Birthday \(daysUntil)", selection: $birthday, displayedComponents: .date).onChange(of: birthday, perform: { value in
                            daysUntil = Birthdays.daysUntil(birthday: birthday)
                        })
                        .onAppear {
                            firstName = person.firstName!
                            lastName = person.lastName!
                            birthday = person.birthday!
                            daysUntil = Birthdays.daysUntil(birthday: birthday)
                        }
                    }
                    Section(header: Text("Notes")) {
                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty && !isEditing {
                                Text("Add notes about person here...")
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 12)
                            }
                            TextEditor(text: $notes)
                                .onTapGesture {
                                    isEditing = true
                                }
                                .frame(minHeight: 75)
                                .onAppear {
                                notes = person.notes!
                            }
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Edit Person")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Update", action: editPerson)
            }
        }
    }
    func editPerson() {
        DataController().editPerson(person: person, firstName: firstName, lastName: lastName, birthday: birthday, notes: notes, avatarData: viewModel.avatar?.pngData() ?? Data(), context: managedObjContext)
        dismiss()
    }
}
