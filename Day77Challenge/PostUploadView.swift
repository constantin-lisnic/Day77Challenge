//
//  PostUploadView.swift
//  Day77Challenge
//
//  Created by Constantin Lisnic on 19/12/2024.
//

import PhotosUI
import SwiftUI

struct PostUploadView: View {
    @Environment(\.dismiss) var dismiss
    @State private var memoryName: String

    var memory: MemoryItem
    var saveData: () -> Void

    init(memory: MemoryItem, saveData: @escaping () -> Void) {
        self.memory = memory
        self.saveData = saveData

        _memoryName = State(initialValue: memory.name)
    }

    var body: some View {
        Form {
            Section {
                TextField("Name your memory", text: $memoryName)
            }

            Section {
                Image(uiImage: memory.uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
        .toolbar {
            Button("Save") {
                memory.name = memoryName
                saveData()
                dismiss()
            }
        }
    }
}

#Preview {
    PostUploadView(memory: MemoryItem(photo: Data()), saveData: {})
}
