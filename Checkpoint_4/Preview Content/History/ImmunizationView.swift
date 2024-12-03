//
//  NewHistoryView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/11/11.
//

import SwiftUI
import CoreData
import AVKit

struct ImmunizationView: View {
    @Environment(\.managedObjectContext) var newImmu
    @Environment(\.presentationMode) var presentation
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    private enum Vaccines: CaseIterable {
        case select
        case hepB
        case rotavirus
        case dtap
        case other
        
        var name: String {
            switch self {
            case .select: return "Select"
            case .hepB: return "Hepatitis B"
            case .rotavirus: return "Rotavirus"
            case .dtap: return "DTaP"
            case .other: return "Other"
            }
        }
        
        var tag: Int {
            switch self {
            case .select: return 0
            case .hepB: return 2
            case .rotavirus: return 3
            case .dtap: return 5
            case .other: return 0
            }
        }
    }
    
    @State private var selectedVaccine = Vaccines.select
    @State private var steps = 1
    @State private var tagVaccine: Int = 1
//    @State private var dose = "1"
    
    @State var year = ""
    @State var month = ""
    @State var day = ""
    @State var dateInput = "0000/00/00"
    
    @State var name: String = ""
    @State var site = ""
    @State var reaction = ""
    @State var manuf = ""
    @State var lot = ""
    @State var ndose = "Select"
    
    @State var doctor = ""
    
    @State var wrongInput: Bool = false
    
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
                
                Text("Name of the Vaccine")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                Picker(selection: $selectedVaccine) {
                    ForEach(Vaccines.allCases, id: \.self) { vaccine in
                        Text(vaccine.name)
                    }
                } label: {
                    Text("Select")
                }.pickerStyle(.menu)
                    .padding(.horizontal, 20)
                    .accentColor(.black)
                    .font(.subheadline)
                
                if(selectedVaccine.tag == 0) {
                    HStack {
                        Text("Other: ")
                        TextField("Type", text: $name)
                            .background(.gray.opacity(0.1))
                    }.padding(.horizontal, 50)
                }
                

                Button(action: {
                    tagVaccine = selectedVaccine.tag + 1
                    steps = 2
                }) {
                    Text("Next")
                        .foregroundStyle(.black)
                        .font(.headline)
                        .bold()
                        .frame(width: 300, height: 40)
                        .border(Color.secondary, width: 3)
                        .backgroundStyle(Color.clear)
                }
                
                if(steps == 2) {
                    Spacer().frame(height: 20)
//                        ForEach(1..<tagVaccine) {num in
                    VStack{
                        HStack {
                            Menu {
                                Button(action: {ndose = "1"}, label: {
                                    Text ("1")
                                })
                                Button(action: {ndose = "2"}, label: {
                                    Text ("2")
                                })
                                Button(action: {ndose = "3"}, label: {
                                    Text ("3")
                                })
                                Button(action: {ndose = "4"}, label: {
                                    Text ("4")
                                })
                                Button(action: {ndose = "5"}, label: {
                                    Text ("5")
                                })
                                Button(action: {ndose = "6"}, label: {
                                    Text ("6")
                                })
                                Button(action: {ndose = "More than 6"}, label: {
                                    Text ("More than 6")
                                })
                            } label: {
                                if(ndose == "Select")
                                {
                                    Text(ndose)
                                        .foregroundStyle(.gray)
                                } else {
                                    Text(ndose)
                                        .foregroundStyle(.black)
                                }
                            }
                            Text("dose")
                            Spacer()
                        }.padding(.horizontal, 10)
                            .padding(.top, 5)
                        HStack {
                            Text("Date: ")
                            TextField("Year", text: $year)
                                .background(.gray.opacity(0.1))
                            Text(" / ")
                            TextField("Month", text: $month)
                                .background(.gray.opacity(0.1))
                            Text(" / ")
                            TextField("Day", text: $day)
                                .background(.gray.opacity(0.1))
                            Spacer()
                        }.padding(.horizontal, 10)
                        Spacer().frame(height: 10)
                        HStack {
                            Text("Manufacturer: ")
                            TextField("Type", text: $manuf)
                                .background(.gray.opacity(0.1))
                            Spacer()
                        }.padding(.horizontal, 10)
                        HStack {
                            Text("Lot. No: ")
                            TextField("Type", text: $lot)
                                .background(.gray.opacity(0.1))
                            Spacer()
                        }.padding(.horizontal, 10)
                        HStack {
                            Text("Injection Site: ")
                            TextField("Type", text: $site)
                                .background(.gray.opacity(0.1))
                            Spacer()
                        }.padding(.horizontal, 10)
                        HStack {
                            Text("Reaction: ")
                            TextField("Type", text: $reaction)
                                .background(.gray.opacity(0.1))
                            Spacer()
                        }.padding(.horizontal, 10)
                        Spacer().frame(height: 10)
                        HStack {
                            Text("Hospital: ")
                            TextField("Type", text: $doctor)
                                .background(.gray.opacity(0.1))
                            Spacer()
                        }.padding(.horizontal, 10)
                            .padding(.bottom, 5)
                    }.frame(width: 350, alignment: .leading)
                        .border(Color.secondary, width: 1)
                    Spacer().frame(height: 20)
//                        }
                    
                    Button(action: addNewImmunization)
                    {
                        Text("Add to Your Diary")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .bold()
                            .frame(width: 300, height: 40)
                            .border(Color.secondary, width: 3)
                            .backgroundStyle(Color.clear)
                    }
                }
                Spacer()
            }
        }
    }
    
    func addNewImmunization() {
        if((year.isEmpty) == false && (month.isEmpty) == false && (day.isEmpty) == false) {
            if(year.count == 4 && month.count <= 2 && day.count <= 2)
            {
                wrongInput = false
                
                let newV = Immunization(context: newImmu)
                
                // Date Input
                if (month.count == 1)
                {
                    month = "0" + month
                }
                
                if (day.count == 1)
                {
                    day = "0" + day
                }
                
                dateInput = year + "/" + month + "/" + day
                newV.vaccinedate = dateInput
                
                // Other
                if(selectedVaccine.tag != 0) {
                    name = String(selectedVaccine.name)
                }
                newV.name = name
                
                newV.site = site
                newV.reaction = reaction
                newV.manuf = manuf
                newV.lot = lot
                newV.doctor = doctor
                
//                if(selectedVaccine.tag != 0) {
//                    ndose = dose
//                }
                newV.dose = ndose
                
                do {
                    try newImmu.save()
                    print("successed to save the data")
                    self.presentation.wrappedValue.dismiss()
                } catch {
                    fatalError("failed to save the data")
                }
            } else {
                wrongInput = true
            }
        } else {
            wrongInput = true
        }
    }
}
