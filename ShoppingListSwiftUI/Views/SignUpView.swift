//
//  SignUpView.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

struct SignUpView: View {
   @EnvironmentObject var list: ShoppingListController
    @State private var username = ""
    @State private var pass = ""
    @State private var email = ""
    @State private var alert = false
    @State private var msg = ""
   // @Binding var show: Bool
    @State private var showOtherView = false
    
    var body : some View{
        
        VStack{
            
           // Image("img")
                
                Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        
                        Text("Email").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Email", text: $email)
                            
                            if email != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Username", text: $username)
                            
                            if username != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                        SecureField("Enter Your Password", text: $pass)
                        
                        Divider()
                    }

                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    self.signUpNewUser(email: self.email, password: self.pass, username: self.username) { (error) in
                        if let error = error {
                            self.msg = error.localizedDescription
                            self.alert.toggle()
                        }
                       // self.show.toggle()
                        self.showOtherView.toggle()
                        
                    }
                    
                }) {
                    
                    Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                    
                }.background(Color("bg"))
                .clipShape(Capsule())
                    .padding(.top, 45).sheet(isPresented: $showOtherView) {
                        
                        HomeView().environmentObject(self.list)
                }
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
    
    private func signUpNewUser(email: String, password: String, username: String, completion: @escaping (Error?) -> Void) {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            print("Fields are missing")
                return
            }
            
           //Without linking accounts
                   Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                       if let error = error {
                           print("Error signing user up with email and password: \(error.localizedDescription)")
                           
                           completion(error)
                           return
                       }
           
                       guard let firUser = result?.user else { return }
           
                       
                       let artUser = User(id: firUser.uid, email: email, username: username)
                       //Upload to Firestore
                    self.createFirestoreUser(user: artUser)
            
                   }
        completion(nil)
            
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
                   
                  }
                  
              }
          }
         
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
