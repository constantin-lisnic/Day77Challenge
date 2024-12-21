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
        case _latitude = "latitude"
        case _longitude = "longitude"
    }

    var name: String = ""
    var photo: Data
    var latitude: Double?
    var longitude: Double?

    init(photo: Data, latitude: Double?, longitude: Double?) {
        self.photo = photo
        self.latitude = latitude
        self.longitude = longitude
    }

    var uiImage: UIImage {
        guard let image = UIImage(data: photo) else {
            fatalError("Could not create UIImage")
        }
        return image
    }

    var coordinate: CLLocationCoordinate2D? {
        if let latitude, let longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        return nil
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
