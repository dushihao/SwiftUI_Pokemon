//
//  Store.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/24.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.settings.checker.isEmailValid.sink {
            isValid in
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
        
        Publishers.CombineLatest(appState.settings.checker.isEmailValid, appState.settings.checker.isPasswordValid).sink { emailValid, isPasswordValid in
            self.dispatch(.registerValid(valid: emailValid && isPasswordValid))
        }.store(in: &disposeBag)
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        // 1
        switch action {
        case .login(let email, let password):
            // 2
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
        case .accountBehaviorDone(result: let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                // 2
                appState.settings.loginUser = user
            case .failure(let error):
                // 3
                print("Error: \(error)")
                appState.settings.loginError = error
            }
        case .logout:
            appState.settings.loginUser = nil
        case .emailValid(valid: let valid):
            appState.settings.isEmailValid = valid
        case .registerValid(valid: let valid):
            appState.settings.isRegisterValid = valid
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            appState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonsCommand()
        case .loadPokemonsDone(let result) :
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons = Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
            case .failure(let error) : print(error)
            }
        }

        return (appState, appCommand)
    }
    
    func dispatch(_ action: AppAction) {
#if DEBUG
        print("[ACTION]: \(action)")
#endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            command.execute(in: self)
        }
    }
}
