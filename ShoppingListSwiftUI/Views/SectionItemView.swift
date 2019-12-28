//
//  SectionItemView.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct SectionItemView: View {
      
      var title: String
      var items: [Item]
      var onTap: ((Item) -> ())
      var onDelete: ((Item) -> ())
      
      var body: some View {
          Section(header: Text(title)) {
              ForEach(self.items, id: \.id) { item in
                  Button(action: {
                      self.onTap(item)
                  }) {
                      HStack {
                          VStack(alignment: .leading) {
                              Text(item.text).font(.largeTitle)
                              Text(self.getDate(item: item)).font(.body)
                          }
                          Spacer()
                          Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                      }
                  }
              }
              .onDelete { (indexSet) in
                  indexSet.forEach {
                      self.onDelete(self.items[$0])
                  }
              }
          }
          
          
      }
      func getDate(item: Item) -> String {
          let date = Date(timeIntervalSince1970: TimeInterval(item.updatedAt.seconds))
          let dateFormatt = DateFormatter();
          dateFormatt.dateFormat = "MM/dd/yyy hh:mm a"
          return dateFormatt.string(from: date)
      }
  }

struct SectionItemView_Previews: PreviewProvider {
    static var previews: some View {
        SectionItemView(title: "Test", items: [Item(id: "sjsdodofvjzof", text: "Testing", isPurchased: false, updatedAt: Timestamp())], onTap: {_ in 
            print("Tapped")
        }, onDelete: {_ in 
            print("delete")
        })
    }
}
