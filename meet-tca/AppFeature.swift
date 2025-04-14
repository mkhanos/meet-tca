//
//  AppFeature.swift
//  meet-tca
//
//  Created by Momo Khan on 4/14/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    // we still use the reduce closure for the core business logic but we don't want to repeat the code from CounterFeature
    var body: some ReducerOf<Self> {
        // Scope reducer allows us to focus on a sub domain of the parent feature and run a reducer on that subdomain
        // We use a scope reducer for each tab, and they each use the same reducer
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        Reduce { state, action in
            
            return .none
        }
    }
}

struct AppView: View {
    // have isolated stores is not ideal if we want them to have the ability to communicate w/ each other
    // we should compose features together and power them with a single store
    let store: StoreOf<AppFeature>
    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }
            CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}
