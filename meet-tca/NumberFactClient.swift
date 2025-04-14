
//
//  NumberFactClient.swift
//  meet-tca
//
//  Created by Momo Khan on 4/14/25.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fetch: (Int) async throws -> String // Abstraction of our dependency. In this case number fact network requests
}

extension NumberFactClient: DependencyKey { // need to provide a live value that is used for devices/sims. this is where we make network requests
    static let liveValue = Self(
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
