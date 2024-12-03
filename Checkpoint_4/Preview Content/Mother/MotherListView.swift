//
//  MotherListView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/21.
//

import SwiftUI
import CoreData
import AVKit

// Health Record View

struct MotherList: View {
    @FetchRequest(sortDescriptors: []) var records: FetchedResults<MotherHealth>
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    var selectedEntity: MotherHealth
    
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
                Text("Mother's Health")
                    .font(.system(size: 40, weight: .heavy, design: .serif))
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding()
                
                Spacer().frame(height: 20)
                Spacer().frame(width: 300, height: 1).background(Color.secondary)
                Spacer().frame(height: 20)
                
                VStack (alignment: .leading) {
                    Text(selectedEntity.date!)
                        .bold()
                        .underline()
                        .font(.system(.title, design: .serif))
                    
                    Spacer().frame(height: 20)
                    
                    Text("Mother's Condition")
                        .bold()
                        .underline()
                        .font(.system(.title3, design: .serif))
                    
                    Text("Pregnancy Weeks: " + selectedEntity.weeks!)
                    Text("Fundal Height: " + selectedEntity.height!)
                    Text("Waist: " + selectedEntity.waist!)
                    Text("Blood Pressure: " + selectedEntity.bptop! + " / " + selectedEntity.bpbottom!)
                    
                    Spacer().frame(height: 10)
                    Text("Medical Record")
                        .font(.system(.title3, design: .serif))
                        .bold()
                        .underline()
                    
                    Text("Edema: " + selectedEntity.edema!)
                    Text("Uric Protein: " + selectedEntity.uprotein!)
                    Text("Uric Glucose: " + selectedEntity.uglucose!)
                    Text("Fetal Heart Beat: " + selectedEntity.fhb!)
                    Text("Weight: " + selectedEntity.weight!)
                    
                    Spacer().frame(height: 10)
                    Text("Note")
                        .font(.system(.title3, design: .serif))
                        .bold()
                        .underline()
                    
                    Text(selectedEntity.note!)
                    
                    Spacer()
                }.frame(width: 300, alignment: .leading)
            }
        }
    }
}

//#Preview {
//    MotherList(records: selectedEntity<MotherHealth>)
//}
