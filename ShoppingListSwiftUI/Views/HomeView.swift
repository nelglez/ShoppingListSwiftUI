//
//  HomeView.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var list: ShoppingListController
    @ObservedObject var connectionStatus = ConnectionStatus()
    @State var text: String = ""
    
      var body: some View {
        
     NavigationView {
               
               List {
               
                   HStack {
                       Image(systemName: "circle.fill").foregroundColor(self.connectionStatus.isOnline ? .green : .red)
                       Text(self.connectionStatus.isOnline ? "Online" : "Offline")
                       
                   }
                   
                   HStack {
                       TextField("Add new item", text: $text)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                       
                       Button("Add") {
                           self.createItem()
                       }.foregroundColor(.blue)
                   }
                   
                   if !self.list.items.filter({!$0.isPurchased}).isEmpty {
                       
                    SectionItemView(title: "Pending", items: self.list.items.filter({!$0.isPurchased}), onTap: self.onTap, onDelete: self.onDelete)
                   }
                   if !self.list.items.filter({$0.isPurchased}).isEmpty {
                    SectionItemView(title: "Purchased", items: self.list.items.filter({$0.isPurchased}), onTap: self.onTap, onDelete: self.onDelete)
                   }
                   }
               .onAppear {
                   self.list.startListener(failure: { error in
                       if let error = error {
                           print(error.localizedDescription)
                       }
                   })
                   self.connectionStatus.startListening()
               }
               .navigationBarTitle("Shopping Cart ⚡️")
               .navigationBarItems(leading: Button(action: {
                do {
                    try Auth.auth().signOut()
                    
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    
                  
                    
                } catch {
                    print(error.localizedDescription)
                }
                
               }, label: {
                Text("Logout")
               }))
               
           }
       }
       
       func createItem() {
           guard !self.text.isEmpty else {
               return
           }
           
           let item = Item(id: UUID().uuidString, text: self.text, isPurchased: false, updatedAt: Timestamp())
           self.list.addItem(item)
           self.text = ""
       }
       
       func onTap(item: Item) {
           self.list.updateItem(item)
       }
       
       func onDelete(item: Item) {
           self.list.removeItem(item)
       }

}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
