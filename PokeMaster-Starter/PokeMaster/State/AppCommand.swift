//
//  AppCommand.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/28.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(
            email: email,
            password: password
        ).publisher
        // 1
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        // 2
                        store.dispatch(.accountBehaviorDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { user in
                    // 3
                    store.dispatch(.accountBehaviorDone(result: .success(user)))
                }
            )
            .seal(in: token)
    }
}

struct LoadPokemonsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadPokemonRequest.all
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadPokemonsDone(result: .failure(error)))
                    }
                    token.unseal()
                }, receiveValue: { value in
                    store.dispatch(.loadPokemonsDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
