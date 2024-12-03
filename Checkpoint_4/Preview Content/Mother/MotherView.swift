//
//  Mother.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/20.
//

import SwiftUI
import CoreData
import AVKit
import Charts

// Mother's Health Record

struct MotherView: View {
    @FetchRequest(sortDescriptors: []) var records: FetchedResults<MotherHealth>
    @Environment(\.managedObjectContext) var viewMother
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    private enum Tabs: String, CaseIterable, Identifiable {
        case Records
        case Graph
        
        var id: String {rawValue}
    }
    
    @State private var selectedTab = Tabs.Records
    @State private var onNewMother = false
    
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
                
                Picker("Mother", selection: $selectedTab) {
                    ForEach(Tabs.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }.pickerStyle(.segmented)
                    .padding(.top, 0)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Spacer()
                
                if(selectedTab == Tabs.Records) {
                    Button (action: {
                        onNewMother = true
                    }) {
                        Text("New Health Record")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .bold()
                            .frame(width: 300, height: 40)
                            .border(Color.secondary, width: 3)
                            .backgroundStyle(Color.clear)
                    }.sheet(isPresented: $onNewMother){
                        NewMotherView()
                    }
                    
                    Spacer().frame(height: 20)
                    Spacer().frame(width: 300, height: 1).background(Color.secondary)
                    
                    if records.isEmpty {
                        Spacer().frame(height: 20)
                        Text("No Record Yet")
                            .font(.title2)
                        Spacer().frame(height: .infinity)
                    } else {
                        List {
                            ForEach(records) { record in
                                if (!record.date!.isEmpty) {
                                    NavigationLink(destination: MotherList(selectedEntity: record)) {
                                        Text(record.date!)
                                    }
                                }
                            }
                        }.scrollContentBackground(.hidden)
                    }
                    
//                    Spacer()
                    
                    Button("Delete Record") {
                        deleteMotherRecord()
                    }
                }
                
                if (selectedTab == Tabs.Graph) {
                    if records.isEmpty {
                        VStack {
                            Text("No Record Yet")
                                .font(.title2)
                            Spacer()
                        }
                    } else {
                        VStack {
                            Text("Weight Change Graph")
                                .font(.system(.headline, design: .serif))
                                .bold()
                            Spacer().frame(height: 20)
                            
                            Chart(records) { record in
                                LineMark(
                                    x: .value("Date", record.date!),
                                    y: .value("Weight", record.weight!)
                                ).foregroundStyle(Color.secondary)
                                PointMark(
                                    x: .value("Date", record.date!),
                                    y: .value("Weight", record.weight!)
                                ).foregroundStyle(Color.black)
                            }.chartYScale(domain: .automatic(reversed: true))
                            .frame(width: 320, height: 400)
                            .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func deleteMotherRecord() {
        for record in records {
            record.checked = true
            if(record.checked) {
                viewMother.delete(record)
            }
        }

        do {
            try viewMother.save() // 変更を保存
        } catch {
            print("Error deleting objects: \(error)")
        }
    }
}

#Preview {
    MotherView()
}
