//
//  User.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    
    init(id: String = "", email: String = "", username: String = "") {
        self.id = id
        self.email = email
        self.username = username
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "username": user.username
        ]
        
        return data
    }
}
