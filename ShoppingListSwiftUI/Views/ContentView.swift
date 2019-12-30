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
    @State private var presentHome = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
        VStack {
            if status {
                HomeView().onDisappear {
                     self.list.items.removeAll()
                    self.list.stopListener()
                    //self.connectionStatus.stopListening()
                }
            } else {
                LoginView()
            }
            
        }.animation(.spring())
        .onAppear {
                
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
                
            }
        }
       
    }
    
    
}

  
