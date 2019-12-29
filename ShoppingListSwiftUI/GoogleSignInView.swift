//
//  GoogleSignInView.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
        
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
        
    }
}
