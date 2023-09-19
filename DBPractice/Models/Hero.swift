//
//  Hero.swift
//  DBPractice
//
//  Created by Marcos on 18/9/23.
//

import Foundation

struct Hero: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}

// Haciendo el encode a mano (Hay que quitar el Decodable de arriba)
//extension Hero: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case description
//        case photo
//        case favorite
//        // case favourite = "favorite" por si queremos cambiarle el nombre
//    }
//
//    init (from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(String.self, forKey: .id)
//        name = try values.decode(String.self, forKey: .name)
//        description = try values.decode(String.self, forKey: .description)
//        photo = try values.decode(URL.self, forKey: .photo)
//        favorite = try values.decode(String.self, forKey: .favorite)
//    }
//}
