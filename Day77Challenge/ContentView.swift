//
//  ContentView.swift
//  Day77Challenge
//
//  Created by Constantin Lisnic on 19/12/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var memories = [MemoryItem]()
    @State private var selectedItem: PhotosPickerItem?
    @State private var newMemory: MemoryItem?

    @State private var isShowingPostUpdateView = false

    let url = URL.documentsDirectory.appending(path: "memories.json")
    let locationFetcher = LocationFetcher()

    init() {
        do {
            let encodedMemories = try String(contentsOf: url, encoding: .utf8)
            let decodedMemories = try JSONDecoder().decode(
                [MemoryItem].self, from: encodedMemories.data(using: .utf8)!)

            _memories = State(initialValue: decodedMemories)
        } catch {
            print("Decoding failed: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(memories) { memory in
                    NavigationLink(value: memory) {
                        HStack {
                            Image(uiImage: memory.uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: 100, height: 100, alignment: .leading
                                )
                                .padding(.horizontal)

                            Text(memory.name)
                        }
                        .alignmentGuide(.listRowSeparatorLeading) { _ in
                            0
                        }
                    }
                }
                .onDelete(perform: removeMemories)
            }
            .navigationTitle("Memories")
            .navigationDestination(for: MemoryItem.self) { memory in
                PostUploadView(memory: memory, saveData: save)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $selectedItem) {
                        Image(systemName: "photo.badge.plus")
                    }
                    .onChange(of: selectedItem, postUploadFunction)
                }

                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isShowingPostUpdateView) {
                if let newMemory {
                    NavigationStack {
                        PostUploadView(memory: newMemory, saveData: save)
                    }
                }
            }
            .onAppear {
                locationFetcher.start()
            }
        }
    }

    func postUploadFunction() {
        Task {
            guard
                let imageData = try await selectedItem?.loadTransferable(
                    type: Data.self)
            else { return }

            let location = locationFetcher.lastKnownLocation

            newMemory = MemoryItem(
                photo: imageData, latitude: location?.latitude,
                longitude: location?.longitude)

            guard let newMemory else { return }

            memories.append(newMemory)

            save()

            selectedItem = nil

            isShowingPostUpdateView = true
        }
    }

    func save() {
        do {
            let sortedMemories = memories.sorted()
            memories = sortedMemories
            let endcodedMemories = try JSONEncoder().encode(sortedMemories)

            try endcodedMemories.write(
                to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
        }
    }

    func removeMemories(at offsets: IndexSet) {
        memories.remove(atOffsets: offsets)
        save()
    }
}

#Preview {
    ContentView()
}
