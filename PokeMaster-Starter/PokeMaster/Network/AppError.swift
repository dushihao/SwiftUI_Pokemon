//
//  AppError.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/27.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    // 2
    var id: String { localizedDescription }
    case passwordWrong
    case networkingFailed(Error)
}
// 3
extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong: return "密码错误"
        case .networkingFailed(let error): return error.localizedDescription
        }
    }
}
