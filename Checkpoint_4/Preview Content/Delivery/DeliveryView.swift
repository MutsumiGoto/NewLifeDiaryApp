//
//  DeliveryView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/22.
//

import SwiftUI
import CoreData
import AVKit

struct DeliveryView: View {
    @FetchRequest(sortDescriptors: []) var reports: FetchedResults<DeliveryMother>
    @FetchRequest(sortDescriptors: []) var records: FetchedResults<DeliveryBaby>
    @Environment(\.managedObjectContext) var viewDelivery
    @Environment(\.managedObjectContext) var viewBaby
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    private enum Who: String, CaseIterable, Identifiable {
        case Delivery
        case Baby
        
        var id: String {rawValue}
    }
    
    @State private var selectedWho = Who.Delivery
    @State private var onNewDeliveryView = false
    @State private var onDeliveryBaby = false
    @State private var viewMoreBaby: Int = 1
    
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
                Text("Delivery Day")
                    .font(.system(size: 40, weight: .heavy, design: .serif))
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding()
                
                Picker("who", selection: $selectedWho) {
                    ForEach(Who.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }.pickerStyle(.segmented)
                    .padding(.top, 0)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Spacer()
                
                if (selectedWho == Who.Delivery) {
                    if reports.isEmpty {
                        Button(action: {
                            onNewDeliveryView = true
                        }) {
                            Text("Add Delivery Report")
                                .foregroundStyle(.black)
                                .font(.headline)
                                .bold()
                                .frame(width: 300, height: 40)
                                .border(Color.secondary, width: 3)
                                .backgroundStyle(Color.clear)
                        }.sheet(isPresented: $onNewDeliveryView){
                            NewDeliveryView()
                        }
                        Spacer().frame(height: 20)
                        Spacer().frame(width: 300, height: 1).background(Color.secondary)
                        Spacer().frame(height: 20)
                        Text("No Record Yet")
                            .font(.title2)
                        Spacer().frame(height: .infinity)
                        
                    } else {
                        VStack (alignment: .leading) {
                            ForEach(reports) { report in
                                Text("Delivery Day")
                                    .bold()
                                    .underline()
                                    .font(.system(.title3, design: .serif))
                                Text(report.deliverydate!)
                                Text(report.ampm! + " " + report.delivery!)
                                Spacer().frame(height: 10)
                                Text("Length of Pregnancy")
                                    .bold()
                                    .underline()
                                    .font(.system(.title3, design: .serif))
                                Text(report.length!)
                                Spacer().frame(height: 10)
                                Text("Medical Report")
                                    .bold()
                                    .underline()
                                    .font(.system(.title3, design: .serif))
                                HStack {
                                    Text("Delivery Type: " + report.type!)
                                    if(report.type! == "Other" && !report.othertype!.isEmpty) {
                                        Text("(" + report.othertype! + ")")
                                    }
                                }
                                Text("Special Notes: " + report.typenotes!)
                                Spacer().frame(height: 10)
                                Text("Length of Labor:")
                                Text(report.labor!)
                                Spacer().frame(height: 10)
                                Text("Amount of Bleeding:")
                                Text(report.bleeding! + " (" + report.ml! + "ml)")
                                Text("Blood Transfusion: " + report.btrans!)
                                Spacer().frame(height: 10)
                                Text("Note: " + report.note!)
                            }
                            Spacer()
                            Button("Delete Your Report") {
                                deleteDeliveryReport()
                            }
                        }.frame(width: 300, alignment: .leading)
                    }
                    Spacer()
                }
                
                if (selectedWho == Who.Baby) {
                    if records.isEmpty {
                        Button(action: {
                            onDeliveryBaby = true
                        }) {
                            Text("Add Baby's Condition")
                                .foregroundStyle(.black)
                                .font(.headline)
                                .bold()
                                .frame(width: 300, height: 40)
                                .border(Color.secondary, width: 3)
                                .backgroundStyle(Color.clear)
                        }.sheet(isPresented: $onDeliveryBaby){
                            BabyConditionView()
                        }
                        
                        Spacer().frame(height: 20)
                        Spacer().frame(width: 300, height: 1).background(Color.secondary)
                        Spacer().frame(height: 20)
                        Text("No Record Yet")
                            .font(.title2)
                        Spacer().frame(height: .infinity)
                    } else {
                        VStack (alignment: .leading) {
                            ForEach(records) {record in
                                Text("Birthday")
                                    .bold()
                                    .underline()
                                    .font(.system(.title3, design: .serif))
                                
                                Text(record.birthday!)
                                
                                Spacer().frame(height: 20)
                                Text("Baby's Condition")
                                    .font(.system(.title3, design: .serif))
                                    .bold()
                                    .underline()
                                HStack {
                                    Text("Weight: ")
                                    Text(record.weight!)
                                    Text("g")
                                }
                                HStack {
                                    Text("Height: ")
                                    Text(record.height!)
                                    Text("cm")
                                }
                                HStack {
                                    Text("Chest Measurement: ")
                                    Text(record.chest!)
                                    Text("cm")
                                }
                                HStack {
                                    Text("Head Circumference: ")
                                    Text(record.head!)
                                    Text("cm")
                                }
                                Spacer().frame(height: 10)
                                Text("Health Check")
                                    .font(.system(.title3, design: .serif))
                                    .bold()
                                    .underline()
                                
                                if(viewMoreBaby == 2){
                                    if !record.milk!.isEmpty {
                                        HStack {
                                            Text("Fed the baby ")
                                            Text(record.milk ?? "N/A")
                                            Text(" for the")
                                        }
                                    }
                                    if !record.hour!.isEmpty {
                                        HStack {
                                            Text("first time " + record.hour! + " hours after")
                                        }
                                        Text("the birth.")
                                        Spacer().frame(height: 10)
                                    }
                                    if !record.test!.isEmpty {
                                        Text("Took tests for congenital diseases:")
                                        Text(record.test!)
                                        Spacer().frame(height: 10)
                                    }
                                    if !record.note!.isEmpty {
                                        Text(record.note!)
                                    }
                                    Button(action: {
                                        viewMoreBaby = 1
                                    }) {
                                        Text("Close")
                                            .foregroundStyle(Color.secondary)
                                    }
                                } else {
                                    Button(action: {
                                        viewMoreBaby = 2
                                    }) {
                                        Text("Read More")
                                            .foregroundStyle(Color.secondary)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button("Delete Your Record") {
                                deleteBabyRecord()
                            }
                        }.frame(width: 300, alignment: .leading)
                    }
                }
                
//                Spacer()
            }
        }
    }
    
    private func deleteDeliveryReport() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeliveryMother")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewDelivery.execute(deleteRequest)
            try viewDelivery.save() // 変更を保存
        } catch {
            print("Error deleting objects: \(error)")
        }
    }
    
    private func deleteBabyRecord() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeliveryBaby")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewBaby.execute(deleteRequest)
            try viewBaby.save() // 変更を保存
        } catch {
            print("Error deleting objects: \(error)")
        }
    }
}

#Preview {
    DeliveryView()
}
