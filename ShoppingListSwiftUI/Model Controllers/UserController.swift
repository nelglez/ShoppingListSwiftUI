//
//  UserController.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class UserController {
      var user = User()
       let auth = Auth.auth()
       let db = Firestore.firestore()
       var userListener: ListenerRegistration? = nil
    
       
        var isGuest: Bool {
           guard let authUser = Auth.auth().currentUser else {
               return true
           }
           if authUser.isAnonymous {
               return true
           } else {
               return false
           }
       }
       
       
       func getCurrentUser() {
           guard let authUser = auth.currentUser else { return }
           
           let userRef = db.collection("users").document(authUser.uid)
           //So any changes will reflect up to date in our app
           userListener = userRef.addSnapshotListener({ (snapshot, error) in
               if let error = error {
                   print(error.localizedDescription)
                   return
               }
               
               guard let data = snapshot?.data() else { return }
               self.user = User(data: data)
               print(self.user)
               
               
           })

       }
}
