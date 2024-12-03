//
//  HomeScreenView.swift
//  Checkpoint_2
//
//  Created by 後藤睦 on R 6/09/29.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color.orange
                    .ignoresSafeArea()
                
                VStack{
                    Text("User Page")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding()
                    
                    HStack{
                        Spacer()
                        Text("Mother")
                            .font(.system(size:30, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .frame(width: 180, height:100)
                            .background(Color.yellow)
                            .cornerRadius(20)
                        Spacer()
                        Text("Child")
                            .font(.system(size:30, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .frame(width: 180, height:100)
                            .background(Color.yellow)
                            .cornerRadius(20)
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Text("Delivery")
                            .font(.system(size:30, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .frame(width: 180, height:100)
                            .background(Color.yellow)
                            .cornerRadius(20)
                        Spacer()
                        Text("History")
                            .font(.system(size:30, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .frame(width: 180, height:100)
                            .background(Color.yellow)
                            .cornerRadius(20)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
