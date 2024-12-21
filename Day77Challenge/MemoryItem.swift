//
//  MemoryItem.swift
//  Day77Challenge
//
//  Created by Constantin Lisnic on 19/12/2024.
//

import Foundation
import Observation
import PhotosUI

@Observable
class MemoryItem: Identifiable, Codable, Comparable, Hashable {
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _photo = "photo"
    }

    var name: String = ""
    var photo: Data

    init(photo: Data) {
        self.photo = photo
    }

    var uiImage: UIImage {
        guard let image = UIImage(data: photo) else {
            fatalError("Could not create UIImage")
        }
        return image
    }

    static func < (lhs: MemoryItem, rhs: MemoryItem) -> Bool {
        lhs.name < rhs.name
    }

    static func == (lhs: MemoryItem, rhs: MemoryItem) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

}
