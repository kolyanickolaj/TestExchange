//
//  HistoryError.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 22.06.25.
//
import Foundation

enum HistoryError: Error {
    case fetchFailed, noData
    
    var description: String {
        switch self {
        case .fetchFailed: return "history.error.fetchFailed".localized
        case .noData: return "history.error.noData".localized
        }
    }
}
