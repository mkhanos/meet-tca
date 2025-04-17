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
        
        await store.send(\.destination.addContact.setName, "Blob Jr") {
            $0.destination?.modify(\.addContact) { $0.contact.name = "Blob Jr" }
        }
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Blob Jr")
        ) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr")
            ]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    @Test
    func addFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        
        await store.send(\.destination.addContact.setName, "Blob Jr")
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.skipReceivedActions()
        
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr")
            ]
            $0.destination = nil
        }
    }
    
}
