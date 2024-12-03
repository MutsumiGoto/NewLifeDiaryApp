//
//  ChildView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/22.
//

import SwiftUI
import CoreData
import AVKit

// Baby Health Record

struct ChildView: View {

    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    @FetchRequest(sortDescriptors: []) var records: FetchedResults<DeliveryBaby>
    @FetchRequest(sortDescriptors: []) var images: FetchedResults<FetusImage>
    @Environment(\.managedObjectContext) var viewChild
    @Environment(\.managedObjectContext) var viewFetus
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    private enum Periods: String, CaseIterable, Identifiable {
        case Fetus
        case Delivery
        case Infant
        case Child
        
        var id: String {rawValue}
    }
    
    @State private var selectedPeriod = Periods.Fetus
    @State private var onFetusView = false
    @State private var onDeliveryView = false
    
    @State var viewHealth = 1
    
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
            
            ScrollView {
                VStack {
                    Text("Child's Health")
                        .font(.system(size: 40, weight: .heavy, design: .serif))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .padding()
                    
                    Picker("child", selection: $selectedPeriod) {
                        ForEach(Periods.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }.pickerStyle(.segmented)
                        .padding(.top, 0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    if(selectedPeriod == Periods.Fetus) {
                        Button(action: {
                            onFetusView = true
                        }) {
                            Text("Add Photo")
                                .foregroundStyle(.black)
                                .font(.headline)
                                .bold()
                                .frame(width: 300, height: 40)
                                .border(Color.secondary, width: 3)
                                .backgroundStyle(Color.clear)
                        }.sheet(isPresented: $onFetusView){
                            FetusView()
                        }
                        
                        Spacer().frame(height: 20)
                        Spacer().frame(width: 300, height: 1).background(Color.secondary)
                        Spacer().frame(height: 20)
                        
                        if(images.isEmpty) {
                            Text("No Record Yet")
                                .font(.title2)
                            Spacer().frame(height: .infinity)
                        } else {
                            ForEach(images) {image in
                                Text(image.date!)
                                    .font(.system(.headline, design: .serif))
                                
                                if image.fimage?.count ?? 0 != 0{
                                    Image(uiImage: UIImage(data: image.fimage ?? Data.init())!)
                                        .resizable()
                                        .frame(width: 300, height: 225)
                                }
                                
                                Text(image.note ?? "")
                                    .font(.system(.body))
                                
                                Spacer().frame(height: 20)
                                Spacer().frame(width: 300, height: 1).background(Color.secondary)
                                Spacer().frame(height: 20)
                            }
                            Button("Delete Images") {
                                deleteFetusImage()
                            }
                        }
//                        Spacer()
                    }
                    
                    if(selectedPeriod == Periods.Delivery) {
                        if records.isEmpty {
                            Button(action: {
                                onDeliveryView = true
                            }) {
                                Text("Add Record")
                                    .foregroundStyle(.black)
                                    .font(.headline)
                                    .bold()
                                    .frame(width: 300, height: 40)
                                    .border(Color.secondary, width: 3)
                                    .backgroundStyle(Color.clear)
                            }.sheet(isPresented: $onDeliveryView){
                                BabyConditionView()
                            }
                            
                            Spacer().frame(height: 20)
                            Spacer().frame(width: 300, height: 1).background(Color.secondary)
                            Spacer().frame(height: 20)
                            Text("No Record Yet")
                                .font(.title2)
                            Spacer().frame(height: .infinity)
                        } else {
                            VStack (alignment: .leading){
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
                                    
                                    if(viewHealth == 2){
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
                                            viewHealth = 1
                                        }) {
                                            Text("Close")
                                                .foregroundStyle(Color.secondary)
                                        }
                                    } else {
                                        Button(action: {
                                            viewHealth = 2
                                        }) {
                                            Text("Read More")
                                                .foregroundStyle(Color.secondary)
                                        }
                                    }
                                }
                                Spacer()
                                
                                Button("Delete Your Record") {
                                    deleteDeliveryBaby()
                                }
                            }.frame(width: 300, alignment: .leading)
                        }
                    }
                    
                    if(selectedPeriod == Periods.Infant){
                        NavigationLink(destination: NewChildView()) {
                            Text("Add New Record")
                                .foregroundStyle(.black)
                                .font(.headline)
                                .bold()
                                .frame(width: 300, height: 40)
                                .border(Color.secondary, width: 3)
                                .backgroundStyle(Color.clear)
                        }
                    }
                }
            }
        }
    }
    
    func deleteFetusImage() {
        for image in images {
            if(image.checked) {
                viewFetus.delete(image)
            }
        }

        do {
            try viewFetus.save()
        } catch {
            fatalError("failed to delete and save")
        }
    }
    
    func deleteDeliveryBaby() {
        for record in records {
            if(record.checked) {
                viewChild.delete(record)
            }
        }

        do {
            try viewChild.save()
        } catch {
            fatalError("failed to delete and save")
        }
    }
}

#Preview {
    ChildView()
}
