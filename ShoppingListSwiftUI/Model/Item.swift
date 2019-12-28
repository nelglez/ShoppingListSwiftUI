//
//  Item.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Item: Identifiable {
    var id: String
    var text: String
    var isPurchased: Bool
    var updatedAt: Timestamp
    
    init(id: String = "", text: String = "", isPurchased: Bool = false, updatedBy: String = "", updatedAt: Timestamp = Timestamp()) {
           self.id = id
           self.text = text
           self.isPurchased = isPurchased
           self.updatedAt = updatedAt
       }
       
       init(data: [String: Any]) {
           id = data["id"] as? String ?? ""
           text = data["text"] as? String ?? ""
           isPurchased = data["isPurchased"] as? Bool ?? false
           updatedAt = data["updatedAt"] as? Timestamp ?? Timestamp()
       }
       
       static func modelToData(item: Item) -> [String: Any] {
           let data: [String: Any] = [
               "id": item.id,
               "text": item.text,
               "isPurchased": item.isPurchased,
               "updatedAt": item.updatedAt
           ]
           
           return data
       }
}
