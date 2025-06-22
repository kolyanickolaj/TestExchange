//
//  Double+Ext.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 22.06.25.
//

import Foundation

extension Double {
    var roundedPresentable: String {
        String(format: "%.2f", self)
    }
}
