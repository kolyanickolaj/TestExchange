//
//  HomeViewError.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 22.06.25.
//

enum HomeError: Error {
    case noInternetConnection
    case someError
    case incorrectInput
    
    var description: String {
        switch self {
        case .noInternetConnection:
            return "home.error.noInternet".localized
        case .someError:
            return "home.error.someError".localized
        case .incorrectInput:
            return "home.error.incorrectInput".localized
        }
    }
}
