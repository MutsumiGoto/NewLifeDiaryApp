//
//  HistoryView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/11/11.
//

import SwiftUI
import CoreData
import AVKit

// Medical Record

struct HistoryView: View {
    @FetchRequest(sortDescriptors: []) var vaccines: FetchedResults<Immunization>
    @Environment(\.managedObjectContext) var viewHistory
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    private enum Tabs: String, CaseIterable, Identifiable {
        case Doctor
        case Vaccine
        case Disease
        
        var id: String {rawValue}
    }
    
    @State private var selectedTabs = Tabs.Vaccine
    @State private var onNewVaccineView = false
    @State private var onNewDiseaseView = false
    
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
                Text("Medical History")
                    .font(.system(size: 40, weight: .heavy, design: .serif))
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding()
                
                Picker("record", selection: $selectedTabs) {
                    ForEach(Tabs.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }.pickerStyle(.segmented)
                    .padding(.top, 0)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Spacer()
                
                if (selectedTabs == Tabs.Vaccine) {
                    Button(action: {
                        onNewVaccineView = true
                    }) {
                        Text("Add Vaccine Record")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .bold()
                            .frame(width: 300, height: 40)
                            .border(Color.secondary, width: 3)
                            .backgroundStyle(Color.clear)
                    }.sheet(isPresented: $onNewVaccineView){
                        ImmunizationView()
                    }
                    
                    Spacer().frame(height: 20)
                    Spacer().frame(width: 300, height: 1).background(Color.secondary)
                    
                    if(vaccines.isEmpty) {
                        Spacer().frame(height: 20)
                        Text("No Record Yet")
                            .font(.title2)
                        Spacer().frame(height: .infinity)
                    } else {
                        List {
                            ForEach(vaccines) { vaccine in
                                if let vaccineName = vaccine.name, !vaccineName.isEmpty {
                                    NavigationLink(destination: VaccineDetail(selectedVaccine: vaccine)) {
                                        Text(vaccineName + ": " + vaccine.dose! + " dose")
                                    }
                                }
                            }
                        }.scrollContentBackground(.hidden)
                        
                        Spacer()
                        
                        Button("Delete Vaccine Records") {
                            deleteVaccineRecords()
                        }
                    }
                }
                
                if(selectedTabs == Tabs.Disease) {
                    Button(action: {
                        onNewDiseaseView = true
                    }) {
                        Text("Add Illness Record")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .bold()
                            .frame(width: 300, height: 40)
                            .border(Color.secondary, width: 3)
                            .backgroundStyle(Color.clear)
                    }.sheet(isPresented: $onNewDiseaseView){
                        NewDiseaseView()
                    }
                    Spacer().frame(height: 20)
                    Spacer().frame(width: 300, height: 1).background(Color.secondary)
                    Spacer().frame(height: 20)
                    Text("No Record Yet")
                        .font(.title2)
                    Spacer().frame(height: .infinity)

//                    Spacer()
                }
            }
        }
    }
    
    private func deleteVaccineRecords() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Immunization")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try viewHistory.execute(deleteRequest)
                try viewHistory.save() // 変更を保存
            } catch {
                print("Error deleting objects: \(error)")
            }
        }
}

#Preview {
    HistoryView()
}
