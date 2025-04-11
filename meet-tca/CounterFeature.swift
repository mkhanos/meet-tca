//
//  CounterFeature.swift
//  meet-tca
//
//  Created by Momo Khan on 4/9/25.
//

import ComposableArchitecture
import SwiftUI

// Features are built using the Reducer() macro and Reducer protocol
// They house business logic without any mention of a view

// Right now we just know this macro conforms it to the Reducer protocol
@Reducer
struct CounterFeature {
    @ObservableState
    struct State { // holds state
        var count = 0
        var isLoading = false
        var fact: String?
    }
    
    enum Action { // all the actions a user can perform in the feature
        case incrementButtonTapped // described as the UI actions rather than what the business logic is meant to do
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String) // our reducer responding to the fact being loaded
    }
    
    // typically we compose reducers together to form complex business logic
    // for simple features one reducer will be fine
    var body: some ReducerOf<Self> { // we must make a body property with a reducer
        Reduce { state, action in // it responds to a user action and lets us mutate state
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none // return value for the Effect to the outside world
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                // we cannot do asyncrhonous work in the reducer, only state mutations
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
            }
        }
    }
}

// later we will need to execute effects, feed data back into the system, manage dependencies, and multiple reducers

// keep reducers and views in the same file until it's crazy
struct CounterView: View {
    let store: StoreOf<CounterFeature> // we make a store that's generic over our reducer that represents the runtime of our feature
    
    var body: some View {
        VStack {
            Text("\(store.count)") // access state via member look up
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped) // send actions via the send method
                }
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                Button("Fact") {
                    store.send(.factButtonTapped)
                }
            }
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
            }
        }
    }
}

#Preview {
    CounterView(store: .init(initialState: CounterFeature.State()) { // provide an initial state for the store as well as the reducer that powers the feature
        CounterFeature() // we can comment out this reducer
    })
}
