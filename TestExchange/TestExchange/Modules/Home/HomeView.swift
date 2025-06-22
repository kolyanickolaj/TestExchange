//
//  HomeView.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                errorView
                    .padding(.bottom, 20)
                
                amountView
                
                fromInputView
                
                toInputView
                
                calculateButton
                    .padding(.top, 20)
                
                resultView
                
                simpleResultView
                
                Spacer()
            }
            .navigationBarItems(trailing: historyButton)
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .fullScreenCover(item: $viewModel.historyDependency) { dependency in
            HistoryView(dependency: dependency)
        }
    }
    
    private var historyButton: some View {
        Button {
            viewModel.historyButtonTapped()
        } label: {
             Image(systemName: "list.bullet")
        }
    }
    
    private var errorView: some View {
        Text(viewModel.error?.description ?? "")
            .foregroundStyle(Color.red)
            .opacity(viewModel.error == nil ? 0 : 1)
            .padding()
    }
    
    private var amountView: some View {
        HStack {
            Text("home.amount".localized)
            
            TextField("", text: $viewModel.amount)
                .keyboardType(.decimalPad)
                .onReceive(Just(viewModel.amount)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        viewModel.amount = filtered
                    }
                }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 1)
        }
    }
    
    private var fromInputView: some View {
        HStack {
            Text("home.from".localized)
            
            Picker("", selection: $viewModel.fromCurrency) {
                ForEach(viewModel.fromCurrencies, id: \.self) { currency in
                    Text("\(currency.code) - \(currency.name)").tag(currency)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 1)
        }
    }
    
    private var toInputView: some View {
        HStack(spacing: 10) {
            Text("home.to".localized)
            
            Picker("", selection: $viewModel.toCurrency) {
                ForEach(viewModel.toCurrencies, id: \.self) { currency in
                    Text("\(currency.code) - \(currency.name)").tag(currency)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 1)
        }
    }
    
    private var calculateButton: some View {
        Button {
            viewModel.calculateButtonTapped()
        } label: {
            Text("home.calculate".localized)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                }
        }
    }
    
    private var resultView: some View {
        VStack(alignment: .center) {
            Text(viewModel.result?.description ?? "")
                .font(.system(size: 12))
                .foregroundStyle(Color.gray)
            
            Text(viewModel.result?.result ?? "")
                .font(.system(size: 24, weight: .semibold))
        }
        .opacity(viewModel.result?.description == nil ? 0 : 1)
        .padding()
    }
    
    private var simpleResultView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.simpleResult?.descriptionFrom ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
                
                Text(viewModel.simpleResult?.descriptionTo ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
                
                Text("home.result.date".localized + " " + (viewModel.simpleResult?.date ?? ""))
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .opacity(viewModel.simpleResult == nil ? 0 : 1)
        .padding()
    }
}

#Preview {
    HomeView(
        viewModel:
            HomeViewModel(
                currencyService: MockCurrencyService(),
                storage: MockStorage(),
                reachabilityService: MockReachabilityService()
            )
    )
}
