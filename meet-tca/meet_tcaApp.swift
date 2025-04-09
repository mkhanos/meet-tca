//
//  meet_tcaApp.swift
//  meet-tca
//
//  Created by Momo Khan on 4/9/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct meet_tcaApp: App {
    static let store = Store(initialState: CounterFeature.State()) { // stores should be created only once, usually at the root of the app
        CounterFeature()
    }
    var body: some Scene {
        WindowGroup {
            CounterView( // alter the entry point of our app to create a view that uses our reducer
                store: meet_tcaApp.store
            )
        }
    }
}
