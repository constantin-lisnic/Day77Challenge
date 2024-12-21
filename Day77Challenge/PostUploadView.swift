//
//  PostUploadView.swift
//  Day77Challenge
//
//  Created by Constantin Lisnic on 19/12/2024.
//

import MapKit
import PhotosUI
import SwiftUI

struct PostUploadView: View {
    @Environment(\.dismiss) var dismiss
    @State private var memoryName: String
    @State private var isShowingMap: Bool = true

    var memory: MemoryItem
    var saveData: () -> Void

    init(memory: MemoryItem, saveData: @escaping () -> Void) {
        self.memory = memory
        self.saveData = saveData

        print(memory.coordinate ?? "No coordinate")

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
            Button(isShowingMap ? "Hide map" : "Show map") {
                isShowingMap.toggle()
            }

            Button("Save") {
                memory.name = memoryName
                saveData()
                dismiss()
            }
        }

        if isShowingMap && memory.coordinate != nil {
            ZStack {
                Map {
                    Marker(memory.name, coordinate: memory.coordinate!)
                }
                .clipShape(.circle)
            }
        } else {
            Text("No location available")
        }
    }
}

#Preview {
    PostUploadView(
        memory: MemoryItem(
            photo: Data(), latitude: 2.4, longitude: 5.3),
        saveData: {})
}
