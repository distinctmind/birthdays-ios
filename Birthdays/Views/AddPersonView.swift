//
//  AddPersonView.swift
//  People
//
//  Created by USER on 2024-03-25.
//

import SwiftUI
import PhotosUI

struct AddPersonView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthday = Date()
    @State private var notes = ""
    @State private var isEditing = false
    @StateObject var viewModel = PersonViewModel()
    
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
                Form {
                    Section(header: Text("Basic Info")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        DatePicker("Birthdate", selection: $birthday, in: ...Date(), displayedComponents: .date)
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
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .gesture(DragGesture().onChanged { _ in
                    // End editing when user starts dragging (scrolling)
                    isEditing = false
                })
            }
            .background(Color(.systemGray6))
            .navigationTitle("Add Person")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add", action: addPerson)
                    }
                }
                .navigationBarTitleDisplayMode(.automatic)
    }
    func addPerson() {
        DataController().addPerson(firstName: firstName, lastName: lastName, birthday: birthday, notes: notes, avatarData: viewModel.avatar?.pngData() ?? Data(), context: managedObjContext)
        dismiss()
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
