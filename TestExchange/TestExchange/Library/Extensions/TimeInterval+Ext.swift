//
//  TimeInterval+Ext.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import Foundation

extension TimeInterval {
    var presentableDate: String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss d MMM YYYY"
        return dateFormatter.string(from: date)
    }
}
