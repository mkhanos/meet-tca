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
    
    @Test
    func timerTests() async {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // this test passes but it doesnt assert anything on the actual test itself
        await store.send(.toggleTimerTapped) { // only this would fail because we still have effects running
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        // this is a flakey test because we are waiting for the timer to tick and the test store might not wait that long
        // we could use a timeout but we want our tests to be fast and deterministic!
        await store.receive(\.timerTick) { // we expect to receive the timer tick action and the count goes up by one on the first one
            $0.count = 1
        }
        await store.send(.toggleTimerTapped) {
            $0.isTimerRunning = false
        }
    }
    
    @Test
    func testNetwork async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is the meaning of life" }
        }
        
        await store.send(.factButtonTapped) { // only checking this without the network fails bc we need to assert on all effects
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse) { // how do we test for the fact that we receive? we must control our dependency by abstracting it and then providing a hardcoded string
            $0.isLoading = false
            $0.fact = "0 is a good number" // we use 0 is a good number because we haven't ticked it up
        }
    }
}
