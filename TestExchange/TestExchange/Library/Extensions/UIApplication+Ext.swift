//
//  UIApplication+Ext.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 23.06.25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
