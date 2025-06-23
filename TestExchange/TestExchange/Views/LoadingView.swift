//
//  LoadingView.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 23.06.25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.6))
                .opacity(0.7)
            
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
        }
    }
}

#Preview {
    LoadingView()
}
