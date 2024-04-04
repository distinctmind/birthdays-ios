//
//  PersonViewModel.swift
//  People
//
//  Created by USER on 2024-04-03.
//

import SwiftUI
import PhotosUI

class PersonViewModel: ObservableObject {
    @Published var selectedAvatar: PhotosPickerItem? {
        didSet { Task { try await loadAvatar() } }
    }
    
    @Published var avatar: UIImage?
    
    func loadAvatar() async throws {
        guard let item = selectedAvatar else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.avatar = uiImage
    }
    
}
