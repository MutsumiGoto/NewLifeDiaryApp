//
//  LogInView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/09/29.
//

import SwiftUI
import FirebaseAuth
import CoreData
import AVKit
//import UIKit

// Log in Page
struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loggedin: Bool = false
    @State private var wrong: Bool = false
    @State var onCreateAccount: Bool = false
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Log in Screen", withExtension: "mov")!)
    
    var body: some View {
        NavigationView{
            ZStack{
                VideoPlayerView(player: player).onAppear {
                    player.play()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                }.ignoresSafeArea()
                .onDisappear {
                    // Remove observer to prevent memory leaks
                    NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                }
                
                Image("Logo_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .position(x: 200, y: 200)
                
                VStack{
                    Spacer()
                        
                    if wrong == true {
                        TextField("", text: $email, prompt: Text("Email").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                            .padding(.top, 30)
                            
                    }
                    else {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300, height:50)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                            .padding(.top, 30)
                    }
                        
                    if wrong == true {
                        SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                    }
                    else {
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                    }
                    
                    Button {
                        loginAccount()
                    } label: {
                        Text("Log in")
                            .foregroundStyle(Color.black)
                            .font(.title2)
                            .bold()
                            .frame(width: 300, height:40)
                            .border(Color.secondary, width: 3)
                            .backgroundStyle(Color.clear)
                    }
                    
                    NavigationLink(destination: HomeScreenView(), isActive: $loggedin){
                        EmptyView()
                    }
                    
//                    NavigationLink(destination: CreateAccountView()){
//                        Text("Create Account")
//                            .font(.title3)
//                            .foregroundStyle(.black)
//                            .underline()
//                            .padding(.top, 30)
//                    }
                    
                    Button{
                        onCreateAccount = true
                    }label: {
                        Text("Create Account")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .underline()
                            .padding(.top, 30)
                    }.sheet(isPresented: $onCreateAccount){
                        CreateAccountView()
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

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.videoGravity = .resizeAspectFill
        playerController.showsPlaybackControls = false
        return playerController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the player view controller if needed
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
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "CreateAccount Screen", withExtension: "mov")!)
    
    var body: some View {
        NavigationView{
            ZStack {
                VideoPlayerView(player: player).onAppear {
                    player.play()
                        player.rate = 0.75
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                        player.seek(to: .zero)
                        player.play()
                            player.rate = 0.75
                    }
                }.ignoresSafeArea()
                .onDisappear {
                    // Remove observer to prevent memory leaks
                    NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                }
                
                VStack{
                    Spacer()
                    Text("New Account")
                        .font(.system(.title, design: .serif))
                        .bold()
                    
                    if wrong == true {
                        TextField("", text: $email, prompt: Text("Invalid Email").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                    }
                    else {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300, height:50)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                    }
                    
                    if wrong == true {
                        TextField("", text: $password, prompt: Text("Invalid Password").foregroundStyle(.red))
                            .padding()
                            .frame(width: 300, height:50)
                            .border(.red)
                            .background(Color.gray.opacity(0.1))
                            .autocapitalization(.none)
                    }
                    else {
                        TextField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.gray.opacity(0.1))
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
                            .border(Color.secondary, width: 3)
                            .background(Color.clear)
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

