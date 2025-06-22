//
//  HistoryView.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let error = viewModel.error {
                    Text(error.description)
                        .foregroundStyle(.red)
                }
                
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(viewModel.items, id: \.self) { item in
                            HistoryItemView(item: item)
                        }
                    }
                }
            }
            .navigationBarItems(leading: closeButton)
            .navigationBarTitle("history.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private var closeButton: some View {
        Button {
            viewModel.backButtonTapped()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
}

#Preview {
    HistoryView(
        dependency:
            HistoryViewDependency(
                storage: MockStorage()
            )
    )
}
