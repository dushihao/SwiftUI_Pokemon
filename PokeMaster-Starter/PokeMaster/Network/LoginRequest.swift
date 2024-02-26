//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/27.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Foundation
import Combine
struct LoginRequest {
    let email: String
    let password: String
    // 1
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            // 2
            DispatchQueue.global()
                .asyncAfter(deadline: .now() + 1.5)
            {
                if self.password == "password" {
                    let user = User(
                        email: self.email,
                        favoritePokemonIDs: []
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(.passwordWrong))
                }
            }
        }
        // 3
        .receive(on: DispatchQueue.main)
        // 4
        .eraseToAnyPublisher()
    }
}
