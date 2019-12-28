//
//  ConnectionStatus.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import Combine
import Firebase

class ConnectionStatus: ObservableObject {
    
    var db = Database.database()
    private var listener: UInt?
    @Published var isOnline = true
    
    func startListening() {
        stopListening()

        listener = db.reference(withPath: ".info/connected").observe(.value) {[weak self] (snapshot) in
            self?.isOnline = snapshot.value as? Bool ?? false
        }
    }
    
    func stopListening() {
        if let listener = listener {
            db.reference(withPath: ".info/connected").removeObserver(withHandle: listener)
            self.listener = nil
        }
        
    }
    
    deinit {
        stopListening()
    }
    
}
