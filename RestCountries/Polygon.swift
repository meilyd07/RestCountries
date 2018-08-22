//
//  Polygon.swift
//  Countries
//
//  Created by Admin on 4/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Properties: Codable {
    let cca2: String
}


struct Geometry {
    let type: String
    let coordinates: Any?
    var coordinates3D: [[[Double]]]? {
        return coordinates as? [[[Double]]]
    }
    var coordinates2D: [[Double]]? {
        return coordinates as? [[Double]]
    }
    var coordinates4D: [[[[Double]]]]? {
        return coordinates as? [[[[Double]]]]
    }
    
    enum CodingKeys: CodingKey {
        case coordinates
        case type
    }
}

struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Polygon: Codable {
    let type: String
    let features: [Feature]
}

extension Geometry: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let array = coordinates as? [[[[Double]]]] {
            try container.encode(array, forKey: .coordinates)
        }
        if let array = coordinates as? [[[Double]]] {
            try container.encode(array, forKey: .coordinates)
        }
        if let array = coordinates as? [[Double]] {
            try container.encode(array, forKey: .coordinates)
        }
    }
}

extension Geometry: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let array = try? values.decode([[[[Double]]]].self, forKey: .coordinates) {
            coordinates = array
        } else if let array = try? values.decode([[[Double]]].self, forKey: .coordinates) {
            coordinates = array
        } else if let array = try? values.decode([[Double]].self, forKey: .coordinates)  {
            coordinates = array
        }
        else {
            coordinates  = nil
        }
        type = try values.decode(String.self, forKey: .type)
    }
}




