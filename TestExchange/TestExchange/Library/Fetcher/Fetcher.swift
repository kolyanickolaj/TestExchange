//
//  Fetcher.swift
//  TestWeather
//
//  Created by Nikolai Lipski on 19.06.25.
//

import Foundation

final class Fetcher: GenericAPI {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        let timeout = 3 * 60.0
        let configuration: URLSessionConfiguration = .default

        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForRequest = timeout
        
        self.init(configuration: configuration)
    }
}
