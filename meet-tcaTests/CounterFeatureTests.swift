//
//  CounterFeatureTests.swift
//  meet-tcaTests
//
//  Created by Momo Khan on 4/11/25.
//

import ComposableArchitecture
import Testing

@testable import meet_tca

@MainActor
struct CounferFeatureTests {
    @Test
    func basics() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped)
        await store.send(.decrementButtonTapped)
    }
}
