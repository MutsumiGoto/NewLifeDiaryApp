//
//  NewDiseaseView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/12/02.
//

import SwiftUI
import CoreData
import AVKit

struct NewDiseaseView: View {
    @Environment(\.presentationMode) var presentation
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    var body: some View {
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
            
            VStack {
                Spacer()
                Text("New Record")
                    .font(.system(.title, design: .serif))
                    .bold()
                Spacer().frame(height: 20)
                
                Text("Name of the Illness")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                Spacer()
            }
        }
    }
}
