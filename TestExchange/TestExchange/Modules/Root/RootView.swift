//
//  RootView.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel
    
    var body: some View {
        viewModel.homeView
    }
}

#Preview {
    RootView(viewModel: RootViewModel())
}
