//
//  LogInView.swift
//  Checkpoint_2
//
//  Created by 後藤睦 on R 6/09/29.
//

import SwiftUI
import FirebaseAuth

// Log in Page

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loggedin: Bool = false
    @State private var wrong: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.orange
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    Text("Mother-and-child \n Notebook")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding()
                        
                    if wrong == true {
                        TextField("", text: $email, prompt: Text("Email").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    else {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300, height:50)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                        
                    if wrong == true {
                        SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    else {
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    
                    Button {
                        loginAccount()
                    } label: {
                        Text("Log in")
                            .foregroundStyle(.black)
                            .font(.title2)
                            .bold()
                            .frame(width: 300, height:40)
                            .background(Color.yellow)
                    }
                    
                    NavigationLink(destination: HomeScreenView(), isActive: $loggedin){
                        EmptyView()
                    }
                    
                    NavigationLink(destination: CreateAccountView()){
                        Text("Create Account")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .underline()
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func loginAccount(){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("error occured in login account", err)
                wrong = true
                email = ""
                password = ""
                return
            }
            print("Logged in to Account")
            loggedin = true
        }
    }
}

#Preview {
    LogInView()
}


// Create Account

struct CreateAccountView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentation
    @State private var wrong: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    if wrong == true {
                        TextField("", text: $email, prompt: Text("Invalid Email").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    else {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300, height:50)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    
                    if wrong == true {
                        TextField("", text: $password, prompt: Text("Invalid Password").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    else {
                        TextField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.30))
                            .autocapitalization(.none)
                    }
                    
                    Button {
                        createAccount()
                    } label: {
                        Text("Create Account")
                            .foregroundStyle(.black)
                            .font(.title2)
                            .bold()
                            .frame(width: 300, height:40)
                            .background(Color.yellow)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func createAccount(){
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("error occured in create account", err)
                wrong = true
                email = ""
                password = ""
                return
            }
            print("Created Account")
            wrong = false
            self.presentation.wrappedValue.dismiss()
        }
    }
}

#Preview {
    CreateAccountView()
}

