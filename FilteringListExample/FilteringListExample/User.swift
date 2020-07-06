//
//  User.swift
//  FilteringListExample
//
//  Created by Paul Hudson on 06/06/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: UUID
    let name: String
    let company: String
    let email: String
    let phone: String
    let address: String
}
