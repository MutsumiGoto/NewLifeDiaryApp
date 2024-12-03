//
//  VaccineDetail.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/11/12.
//

import SwiftUI
import CoreData
import AVKit

// Immunization View

struct VaccineDetail: View {
    @FetchRequest(sortDescriptors: []) var records: FetchedResults<Immunization>
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    var selectedVaccine: Immunization
    
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
                Text("Vaccine Record")
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
                    Text(selectedVaccine.name! + ": " + selectedVaccine.dose! + " dose")
                        .bold()
                        .underline()
                        .font(.system(.title, design: .serif))
                    
                    Spacer().frame(height: 20)
                    
                    Text("Date of Vaccination")
                        .bold()
                        .underline()
                        .font(.system(.title3, design: .serif))
                    Text(selectedVaccine.vaccinedate!)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Vaccine Information")
                        .bold()
                        .underline()
                        .font(.system(.title3, design: .serif))
                    Text("Manufacturer: " + selectedVaccine.manuf!)
                    Text("Lot. No: " + selectedVaccine.lot!)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Medical Record")
                        .bold()
                        .underline()
                        .font(.system(.title3, design: .serif))
                    Text("Injection Site: " + selectedVaccine.site!)
                    Text("Reaction: " + selectedVaccine.reaction!)
                    Text("Physician: " + selectedVaccine.doctor!)
                    
                     Spacer()
                }.frame(width: 300, alignment: .leading)
            }
        }
    }
}
