//
//  ContactsFeature.swift
//  meet-tca
//
//  Created by Momo Khan on 4/14/25.
//

import ComposableArchitecture
import SwiftUI

struct Contact: Identifiable, Equatable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactFeature.State? // integrates states together, nil means not presented, non-nil means presented
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>) // integrates actions together
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                // present the feature with the initial state
                state.addContact = AddContactFeature.State(
                    contact: Contact(id: UUID(), name: "")
                )
                return .none
            case .addContact:
                return .none
            // when the add contact feature is presented and the cancel button is tapped in the feature we dismiss the feature
            // parent feature creates state to drive navigation
            case .addContact(.presented(.cancelButtonTapped)):
                state.addContact = nil
                return .none
            case .addContact(.presented(.saveButtonTapped)):
                guard let contact = state.addContact?.contact else { return .none }
                state.contacts.append(contact)
                state.addContact = nil
                return .none
                
            }
        }
        .ifLet(\.$addContact, action: \.addContact) { // runs the child reducer when a child action comes in
            AddContactFeature()
        }
    }
}

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(contact.name)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(), name: "Blob"),
                    Contact(id: UUID(), name: "Blob Jr"),
                    Contact(id: UUID(), name: "Blob Sr"),
                ]
            )
        ) {
            ContactsFeature()
        }
    )
}
