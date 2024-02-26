//
//  User.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/25.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String
    var favoritePokemonIDs: Set<Int>
    func isFavoritePokemon(id: Int) -> Bool {
        favoritePokemonIDs.contains(id)
    }
}
