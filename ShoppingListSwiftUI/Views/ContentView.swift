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
    @State private var status = false
    var body: some View {
        VStack {
            if userController.isGuest || !status {
            LoginView()
        } else {
            HomeView()
        }
        }.animation(.spring())
        .onAppear {
                
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
                let status = true
                self.status = status
            }
        }
       
    }
    
    
}

  
