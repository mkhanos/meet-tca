//
//  AppFeatureTests.swift
//  meet-tcaTests
//
//  Created by Momo Khan on 4/14/25.
//

import ComposableArchitecture
import Testing

@testable import meet_tca

@MainActor
struct AppFeatureTests {

    @Test
    func incrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }

}
