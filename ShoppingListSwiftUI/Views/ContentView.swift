//
//  ContentView.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var list: ShoppingListController
    var userController = UserController()
    var body: some View {
        VStack {
            if userController.isGuest {
            LoginView()
        } else {
            HomeView()
        }
        }
       
    }
    
    
}

  
