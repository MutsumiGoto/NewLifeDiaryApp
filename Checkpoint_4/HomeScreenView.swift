//
//  HomeScreenView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/09/29.
//

import SwiftUI
import CoreData
import AVKit

struct HomeScreenView: View {
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    var body: some View {
        NavigationView{
            ZStack{
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
                
                VStack(alignment: .leading){
                    Spacer().frame(height: 30)
                    HStack {
                        Spacer()
                            Text("New Life Diary")
                                .font(.system(size: 35, weight: .heavy, design: .serif))
                                .font(.largeTitle)
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .padding()
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Text("Calender")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                         Spacer()
                        Text("......................  1")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    
                    HStack {
                        NavigationLink(destination: MotherView()) {
                            Text("Mother")
                                .font(.system(size:30))
                                .underline()
                                .foregroundStyle(Color.black)
                                .padding(5)
                            //                            .frame(width: 180, height:100)
                            //                            .border(Color.secondary, width: 3)
                            //                            .background(Color.clear)
                        }
                        Spacer()
                        Text(".........................  2")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    HStack {
                        NavigationLink(destination: ChildView()) {
                            Text("Child")
                                .font(.system(size:30))
                                .underline()
                                .foregroundStyle(Color.black)
                                .padding(5)
                            //                            .frame(width: 180, height:100)
                            //                            .border(Color.secondary, width: 3)
                            //                            .background(Color.clear)
                        }
                        Spacer()
                        Text(".............................  3")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    
                    HStack {
                        NavigationLink(destination: DeliveryView()) {
                            Text("Delivery")
                                .font(.system(size:30))
                                .underline()
                                .foregroundStyle(Color.black)
                                .padding(5)
    //                            .frame(width: 180, height:100)
    //                            .border(Color.secondary, width: 3)
    //                            .background(Color.clear)
                        }
                        Spacer()
                        Text(".......................  4")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    
                    HStack {
                        NavigationLink(destination: HistoryView()) {
                            Text("History")
                                .font(.system(size:30))
                                .underline()
                                .foregroundStyle(Color.black)
                                .padding(5)
                            //                            .frame(width: 180, height:100)
                            //                            .border(Color.secondary, width: 3)
                            //                            .background(Color.clear)
                        }
                        Spacer()
                        Text("........................  6")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    
                    HStack {
                        Text("Memory")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                        Spacer()
                        Text(".......................  7")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    
                    HStack {
                        Text("Setting")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                        Spacer()
                        Text(".........................  8")
                            .font(.system(size:30))
                            .foregroundStyle(Color.black)
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Image("Bird Mark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        Spacer()
                    }
                    Spacer()
                }.padding(40)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeScreenView()
}
