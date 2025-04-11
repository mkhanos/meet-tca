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
        let store = TestStore(initialState: CounterFeature.State()) { // create a test store the same way a regular store
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) { // send actions
            $0.count = 1 // our responsibility to change the state to what it will be after the event
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
