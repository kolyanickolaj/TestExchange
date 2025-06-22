//
//  HistoryViewModel.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import SwiftUI
import Combine

final class HistoryViewModel: ObservableObject {
    @Published var items: [HistoryItem] = []
    @Published var searchText = ""
    private let storage: StorageProtocol
    private let subject: any Subject<HistoryResult, Never>
    private var error: HistoryError?
    private var bag = Set<AnyCancellable>()
    
    init(
        storage: StorageProtocol,
        subject: any Subject<HistoryResult, Never>
    ) {
        self.storage = storage
        self.subject = subject
    }
    
    func onAppear() {
        fetchInitialData()
        bind()
    }
    
    func backButtonTapped() {
        subject.send(.close)
    }
    
    private func fetchInitialData() {
        Task { @MainActor in
            do {
                items = try storage.fetch()
                if items.isEmpty {
                    error = .noData
                }
            } catch {
                self.error = .fetchFailed
            }
            
        }
    }
    
    private func bind() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.error = nil
                
                guard !value.isEmpty else {
                    self?.error = nil
                    self?.fetchInitialData()
                    return
                }
                
                self?.fetchData(value)
            }
            .store(in: &bag)
    }
    
    private func fetchData(_ searchText: String) {
        let baseFilter = Filter(key: .baseCode, value: searchText, condition: .contains)
        let targetFilter = Filter(key: .targetCode, value: searchText, condition: .contains)
        do {
            items = try storage.fetch(with: [baseFilter, targetFilter], logic: .or)
            if items.isEmpty {
                error = .noData
            }
        } catch {
            self.error = .fetchFailed
        }
    }
}
