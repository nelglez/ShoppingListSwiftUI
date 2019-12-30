//
//  ShoppingListController.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class ShoppingListController: ObservableObject {
    
    @Published var items: [Item] = []
    private var listener: ListenerRegistration?
    private var db = Firestore.firestore().collection("shopping_notes")
    
    func startListener(failure: @escaping (Error?) -> Void) {
        stopListener()
        
        listener = db
            .order(by: "isPurchased", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    failure(error)
                    return
                }
                
//                guard let documents = snapshot?.documents else {
//                    result(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is empty"])))
//                    return
//                }
                snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let item = Item(data: data)
//                let items = documents.map { Item(data: $0) }
                   switch change.type {
                   case .added:
                       self.onDocumentAdded(change: change, item: item)
                   case .modified:
                       self.onDocumentModified(change: change, item: item)
                   case .removed:
                       self.onDocumentRemoved(change: change)
                       
                   }
                    })
        }
    }
    
    private func onDocumentAdded(change: DocumentChange, item: Item) {
        let newIndex = Int(change.newIndex)
        items.insert(item, at: newIndex)
        
    }
    
    private func onDocumentModified(change: DocumentChange, item: Item) {
        if change.newIndex == change.oldIndex {
            //Item changed but it is still in the same position
            let index = Int(change.newIndex)
            items[index] = item
            
        } else {
            //Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            items.remove(at: oldIndex)
            items.insert(item, at: newIndex)
            
        }
    }
    
    private func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        items.remove(at: oldIndex)
        
        
    }
    
    func addItem(_ item: Item) {
        db.document(item.id).setData(Item.modelToData(item: item))
    }
    
    func updateItem(_ item: Item) {
        var _item = item
        _item.isPurchased.toggle()
        updateItemInDB(_item)
    }
    func updateItemInDB(_ item: Item) {
        db.document(item.id).updateData(Item.modelToData(item: item))
    }
    
    func removeItem(_ item: Item) {
        db.document(item.id).delete()
    }
    
    func stopListener() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        stopListener()
    }
    
}
