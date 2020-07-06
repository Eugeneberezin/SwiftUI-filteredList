//
//  ContentView.swift
//  FilteringListExample
//
//  Created by Paul Hudson on 06/06/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
        }
        )
    }
}

struct FilteringList<T: Identifiable, Content: View>: View {
    @State private var filteredItems = [T]()
    @State private var filterString = ""
    let listItems: [T]
    let filterKeyPaths: [KeyPath<T, String>]
    let content: (T) -> Content
    
    var body: some View {
        VStack {
            TextField("Type to filter", text: $filterString.onChange(applyFilter))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List(filteredItems, rowContent: content)
            .onAppear(perform: applyFilter)
        }    }
    
    init(_ data: [T], filterKeys: KeyPath<T, String>..., @ViewBuilder rowContent: @escaping (T) -> Content) {
        listItems = data
        filterKeyPaths = filterKeys
        content = rowContent
    }
    
    func applyFilter() {
        let cleanedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedFilter.isEmpty {
            filteredItems = listItems
        } else {
            filteredItems = listItems.filter { element in
                filterKeyPaths.contains {
                    element[keyPath: $0].localizedCaseInsensitiveContains(cleanedFilter)
                }
                
            }
        }
    }
}

struct ContentView: View {
    let users = Bundle.main.decode([User].self, from: "users.json")
    
    
    var body: some View {
        NavigationView{
            FilteringList(users, filterKeys: \.name, \.address, rowContent: { user  in
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.address)
                        .foregroundColor(.secondary)
                    
                }
            })
            .navigationBarTitle("Address Book")
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
