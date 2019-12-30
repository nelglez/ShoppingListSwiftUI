//
//  AppDelegate.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//https://github.com/alfianlosari/SwiftUIRealtimeShoppingCart

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

let clientID = "585508378371-18qr1p2b2itul0le3lh6co2ho3es0on8.apps.googleusercontent.com"
  
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//      if let error = error {
//        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//          print("The user has not signed in before or they have since signed out.")
//        } else {
//          print("\(error.localizedDescription)")
//        }
//        return
//      }
//
//      // Perform any operations on signed in user here.
//      let userId = user.userID                  // For client-side use only!
//      let idToken = user.authentication.idToken // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
//      let email = user.profile.email
//      // ...
//      //  guard let firUser = user else { return }
//
//
//        let artUser = User(id: userId!, email: email!, username: givenName!)
//                    //Upload to Firestore
//                 self.createFirestoreUser(user: artUser)
//    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    
         if let error = error {
           
           print(error.localizedDescription)
           return
         }

         guard let authentication = user.authentication else { return }
         let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
           
           Auth.auth().signIn(with: credential) { (res, err) in
               
               if err != nil {
                   
                   print((err?.localizedDescription)!)
                   return
               }
               
               print(res!.user.email)
        
           }
        
        // Perform any operations on signed in user here.
                         let userId = user.userID                  // For client-side use only!
                         let idToken = user.authentication.idToken // Safe to send to the server
                         let fullName = user.profile.name
                         let givenName = user.profile.givenName
                         let familyName = user.profile.familyName
                         let email = user.profile.email
                        
                           let artUser = User(id: userId!, email: email!, username: givenName!)
                                       //Upload to Firestore
                   
                  
                                    self.createFirestoreUser(user: artUser)
               
     
       }

       func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

       }
    
    private func createFirestoreUser(user: User) {
                 //Create document Ref
                 let newUserRef = Firestore.firestore().collection("users").document(user.id)
                 //Create Model Data
                 let data = User.modelToData(user: user)
                 //Upload to fireStore
                 newUserRef.setData(data) { (error) in
                     if let error = error {
                        
                         print("Unable to upload user: \(error.localizedDescription)")
                      
                       return
                     } else {
                         print("New User Created")
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                      
                     }
                     
                 }
             }
    
   

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

