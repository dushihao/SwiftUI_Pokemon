//
//  AppAction.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/27.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Foundation

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case logout
    case emailValid(valid: Bool)
    
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
}
