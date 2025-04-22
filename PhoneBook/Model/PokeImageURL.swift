//
//  PokeImageURL.swift
//  PhoneBook
//
//  Created by 최규현 on 4/21/25.
//

struct PokeImageURL: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
