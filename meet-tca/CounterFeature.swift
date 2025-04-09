//
//  CounterFeature.swift
//  meet-tca
//
//  Created by Momo Khan on 4/9/25.
//

import ComposableArchitecture

// Features are built using the Reducer() macro and Reducer protocol
// They house business logic without any mention of a view

// Right now we just know this macro conforms it to the Reducer protocol
@Reducer
struct CounterFeature {
    @ObservableState
    struct State { // holds state
        var count = 0
    }
    
    enum Action { // all the actions a user can perform in the feature
        case incrementButtonTapped // described as the UI actions rather than what the business logic is meant to do
        case decrementButtonTapped
    }
    
    // typically we compose reducers together to form complex business logic
    // for simple features one reducer will be fine
    var body: some ReducerOf<Self> { // we must make a body property with a reducer
        Reduce { state, action in // it responds to a user action and lets us mutate state
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none // return value for the Effect to the outside world
                
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}

// later we will need to execute effects, feed data back into the system, manage dependencies, and multiple reducers
