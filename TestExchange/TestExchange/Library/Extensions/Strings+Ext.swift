//
//  Strings+Ext.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//
import Foundation

extension String {
    public var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
