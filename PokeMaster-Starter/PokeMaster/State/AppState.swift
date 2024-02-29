//
//  AppState.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/24.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Combine
import SwiftUI

struct AppState {
    var settings = Settings()
    var pokemonList = PokemonList()
}

extension AppState {
    // 2
    struct Settings {
        enum Sorting: String, CaseIterable {
            case id, name, color, favorite
        }
        @UserDefaultProperty(key: "showEnglishName", defaultValue: true) var showEnglishName
       // AppStorage注解 https://fatbobman.com/zh/posts/appstorage/
        @AppStorage("sorting") var sorting = Sorting.id
        var showFavoriteOnly = false
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            // 1. isEmailValid 是一个验证用户输入的 Publisher。我们稍后会订阅它，并用它来更新 UI
            var isEmailValid: AnyPublisher<Bool, Never> {
                // 2. remoteVerify 是构成整个 isEmailValid 的一部分，它负责调用 Server API 来验证有效性。首先，针对 $email 使用 debounce 和 removeDuplicates 来控制用户输入，它将为我们过滤掉输入抖动和重复输入，这样我们将能尽量减少 API 调用。
                let remoteVerify = $email.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        // 3. 如果 validEmail 为 false，那说明输入的邮箱地址在本地就被验证为无效，就不需要再进一步去发送检查了。
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail,  canSkip) {
                        case (false, _): return Just(false).eraseToAnyPublisher()
                        // 4. “如果本地检查通过，而且我们处于注册页面时，发送 EmailCheckingRequest 请求。
                        case (true, false):
                            return EmailCheckingRequest(email: email).publisher.eraseToAnyPublisher()
                        case (true, true): return Just(true).eraseToAnyPublisher()
                        }
                    }
                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
            
                // 5. 把 remoteVerify 和其他状态组合起来，返回最终代表 email 是否有效的 Publisher
                return Publishers.CombineLatest3(emailLocalValid, canSkipRemoteVerify, remoteVerify)
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }
            
            // 实现一个新的 Publisher，检查 password 和 verifyPassword 不为空，而且两者的的值相等
            var isPasswordValid: AnyPublisher<Bool, Never> {
                let passwordValid = $password.map { !$0.isEmpty }
                let verifyPassword = $verifyPassword.map { !$0.isEmpty }
                return Publishers.CombineLatest(passwordValid, verifyPassword)
                    .map { $0 && $1 }
                    .map {
                        guard $0 else { return false }
                        return self.password == self.verifyPassword
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        var checker = AccountChecker()
        
        var isEmailValid: Bool = false
        var isRegisterValid: Bool = false
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        var loginRequesting = false
        var loginError: AppError?
    }
}

extension AppState {
    struct PokemonList {

        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?
        var loadingPokemons = false

        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
    }
}

