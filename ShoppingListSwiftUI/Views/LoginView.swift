//
//  LoginView.swift
//  ShoppingListSwiftUI
//
//  Created by Nelson Gonzalez on 12/28/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
     @EnvironmentObject var list: ShoppingListController
   @State var email = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    @State private var showingHome = false
    
    var body: some View{
        
        VStack{
            
        //    Image("img")
            
            Text("Sign In").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
            
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
                    
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                    SecureField("Enter Your Password", text: $pass)
                    
                    Divider()
                }

            }.padding(.horizontal, 6)
            
            Button(action: {
                
                self.signInWithEmail(email: self.email, password: self.pass) { (verified, status) in
                    
                    if !verified {
                        
                        self.msg = status
                        self.alert.toggle()
                        return
                    }
                        
                       print("Success")
                        
                    
                
                }
                self.showingHome.toggle()
                
            }) {
                
                Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                
                
            }.background(Color("bg"))
            .clipShape(Capsule())
                .padding(.top, 45).sheet(isPresented: $showingHome) {
                    HomeView().environmentObject(self.list)
            }
           
            BottomView()
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
    
    func signInWithEmail(email: String, password : String, completion: @escaping (Bool,String)-> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if err != nil{
                
                completion(false, (err?.localizedDescription)!)
                return
            }
            
            completion(true, (res?.user.email)!)
        }
    }
}

struct BottomView: View{
    @State var show = false
    
    var body : some View{
        
        VStack{
            
            Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
            
            GoogleSignInView().frame(width: 150, height: 55)
            
            HStack(spacing: 8){
                
                Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                   Text("Sign Up")
                    
                }.foregroundColor(.blue)
                
            }.padding(.top, 25)
            
        }.sheet(isPresented: $show) {
            
            SignUpView()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
