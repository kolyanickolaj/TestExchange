//
//  HistoryItemView.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 22.06.25.
//

import SwiftUI

struct HistoryItemView: View {
    let item: HistoryItem
    
    var body: some View {
        VStack(spacing: 5) {
            Text(description)
                
            Text(item.timestamp.presentableDate)
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
        }
        .padding(.horizontal)
    }
    
    private var description: String {
        let base = "\(item.value.roundedPresentable)\(item.base.code)"
        let resultAmount = item.value*item.rate
        let result = "\(resultAmount.roundedPresentable)\(item.target.code)"
        return base + " ⇌ " + result
    }
}

#Preview {
    HistoryItemView(item: .mock)
}
