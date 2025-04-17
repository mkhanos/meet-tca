//
//  ContactFeatureTests.swift
//  meet-tcaTests
//
//  Created by Momo Khan on 4/17/25.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import meet_tca

struct ContactFeatureTests {

    @Test
    func addFlow() async {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: Contact(id: UUID(0), name: "") // need to control the UUID dependency
                )
            )
        }
    }

}
