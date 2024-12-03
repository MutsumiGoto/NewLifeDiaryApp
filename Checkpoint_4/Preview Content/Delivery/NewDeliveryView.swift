//
//  NewDeliveryView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/22.
//

import SwiftUI
import CoreData
import AVKit

struct NewDeliveryView: View {
    @Environment(\.managedObjectContext) var newDelivery
    @Environment(\.presentationMode) var presentation
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    @State var year = ""
    @State var month = ""
    @State var day = ""
    @State var ampm: String = "Option"
    @State var hour = ""
    @State var minute = ""
    @State var dateInput = "0000/00/00"
    
    @State var lweeks: String = ""
    @State var ldays: String = ""
    
    @State var type: String = "Option"
    @State var othertype: String = ""
    @State var typenotes: String = ""
    
    @State var laborday: String = ""
    @State var laborhour: String = ""
    @State var laborminute: String = ""
    
    @State var bleeding: String = "Option"
    @State var ml: String = ""
    @State var btrans: String = "Option"
    
    @State var note: String = ""
    
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
                
                Text("Delivery Date and Time")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                HStack {
                    TextField("Year", text: $year)
                        .background(.gray.opacity(0.1))
                    Text(" / ")
                    TextField("Month", text: $month)
                        .background(.gray.opacity(0.1))
                    Text(" / ")
                    TextField("Day", text: $day)
                        .background(.gray.opacity(0.1))
                }.padding(.horizontal, 50)
                HStack {
                    Menu {
                        Button(action: {ampm = "AM"}, label: {
                            Text("AM")
                        })
                        Button(action: {ampm = "PM"}, label: {
                            Text("PM")
                        })
                    } label: {
                        if (ampm == "Option") {
                            Text(ampm)
                                .foregroundStyle(.gray)
                        }
                        else {
                            Text(ampm)
                                .foregroundStyle(.black)
                        }
                    }
                    TextField("Hour", text: $hour)
                        .frame(width: 70)
                        .background(.gray.opacity(0.1))
                    Text(" : ")
                    TextField("Minute", text: $minute)
                        .frame(width: 70)
                        .background(.gray.opacity(0.1))
                }.padding(.horizontal, 50)
                
                Spacer().frame(height: 10)
                
                Text("Length of Pregnancy")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                HStack {
                    TextField("Type", text: $lweeks)
                        .frame(width: 60)
                        .background(.gray.opacity(0.1))
                    Text("weeks")
                    TextField("Type", text: $ldays)
                        .frame(width: 60)
                        .background(.gray.opacity(0.1))
                    Text("days")
                }.padding(.horizontal, 50)
                
                Spacer().frame(height: 20)
                
                Text("Medical Report")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                VStack {
                    HStack {
                        Text("Delivery Type:")
                            .bold()
                        Spacer()
                    }.padding(.top, 5)
                        .padding(.horizontal, 10)
                    HStack {
                        Text("Type:")
                        Menu {
                            Button(action: {type = "Normal Position"}, label: {
                                Text("Normal Position")
                            })
                            Button(action: {type = "Breech Position"}, label: {
                                Text("Breech Position")
                            })
                            Button(action: {type = "Other"}, label: {
                                Text("Other")
                            })
                        } label: {
                            if (type == "Option") {
                                Text(type)
                                    .foregroundStyle(.gray)
                            }
                            else if (type == "Other") {
                                Text("")
                                    .foregroundStyle(.black)
                            }
                            else {
                                Text(type)
                                    .foregroundStyle(.black)
                            }
                        }
                        if (type == "Other") {
                            TextField("Type", text: $othertype)
                                .background(.gray.opacity(0.1))
                        }
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Special Notes: ")
                        TextField("Type", text: $typenotes)
                            .background(.gray.opacity(0.1))
                        Spacer()
                    }.padding(.horizontal, 10)
                    Spacer().frame(height: 20)
                    HStack {
                        Text("Length of Labor:")
                            .bold()
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        TextField("Type", text: $laborday)
                            .frame(width: 50)
                            .background(.gray.opacity(0.1))
                        Text("days")
                        TextField("Type", text: $laborhour)
                            .frame(width: 50)
                            .background(.gray.opacity(0.1))
                        Text("hours")
                        TextField("Type", text: $laborminute)
                            .frame(width: 50)
                            .background(.gray.opacity(0.1))
                        Text("mins")
                        Spacer()
                    }.padding(.horizontal, 10)
                    Spacer().frame(height: 20)
                    HStack {
                        Text("Amount of Bleeding:")
                            .bold()
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Amount")
                        Menu {
                            Button(action: {bleeding = "Light"}, label: {
                                Text("Light")
                            })
                            Button(action: {bleeding = "Moderate"}, label: {
                                Text("Moderate")
                            })
                            Button(action: {bleeding = "Heavy"}, label: {
                                Text("Heavy")
                            })
                        } label: {
                            if (bleeding == "Option") {
                                Text(bleeding)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(bleeding)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                        Text("( ")
                        TextField("Type", text: $ml)
                            .frame(width: 45)
                            .background(.gray.opacity(0.1))
                        Text("ml )")
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Blood Transfusion")
                        Menu {
                            Button(action: {btrans = "Yes"}, label: {
                                Text("Yes")
                            })
                            Button(action: {btrans = "No"}, label: {
                                Text("No")
                            })
                        } label: {
                            if (btrans == "Option") {
                                Text(btrans)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(btrans)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 5)
                }.frame(width: 350)
                    .border(Color.secondary, width: 1)
                
                TextEditor(text: $note)
                    .scrollContentBackground(Visibility.hidden)
                    .background(Color.gray.opacity(0.1))
                    .frame(width: 350, height: 100)
                    .overlay(alignment: .topLeading){
                        if note.isEmpty {
                            Text("Note")
                                .foregroundStyle(.gray)
                                .allowsHitTesting(false)
                                .padding()
                        }
                    }
                
                Spacer().frame(height: 20)
                
                if (wrongInput == true) {
                    Text("Something went wrong.\nPlease review your input.")
                        .font(.body)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: addReport)
                {
                    Text("Add to Your Diary")
                        .foregroundStyle(.black)
                        .font(.headline)
                        .bold()
                        .frame(width: 300, height: 40)
                        .border(Color.secondary, width: 3)
                        .backgroundStyle(Color.clear)
                }
                
                Spacer()
            }
        }
    }
    
    func addReport() {
        if((year.isEmpty) == false && (month.isEmpty) == false && (day.isEmpty) == false) {
            if(year.count == 4 && month.count <= 2 && day.count <= 2)
            {
                wrongInput = false
                
                let newObject = DeliveryMother(context: newDelivery)
                
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
                newObject.deliverydate = dateInput
                
                // Other
                newObject.delivery = (hour + ":" + minute)

                newObject.length = (lweeks + " weeks " + ldays + " days")
                
                newObject.othertype = othertype
                newObject.typenotes = typenotes

                newObject.labor = (laborday + " days " + laborhour + " hours " + laborminute + " minutes")
                
                newObject.ml = ml
                newObject.note = note
                
                // Dropdown
                if(ampm == "Option") {
                    ampm = ""
                }
                if(type == "Option") {
                    type = ""
                }
                if(bleeding == "Option") {
                    bleeding = ""
                }
                if(btrans == "Option") {
                    btrans = ""
                }
                
                newObject.ampm = ampm
                newObject.type = type
                newObject.bleeding = bleeding
                newObject.btrans = btrans
                
                do {
                    try newDelivery.save()
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

    
#Preview {
    NewDeliveryView()
}
