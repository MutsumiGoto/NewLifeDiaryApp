//
//  NewMotherView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/20.
//

import SwiftUI
import CoreData
import AVKit

struct NewMotherView: View {
    @Environment(\.managedObjectContext) var newMother
    @Environment(\.presentationMode) var presentation
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    @State var year = ""
    @State var month = ""
    @State var day = ""
    @State var dateInput = ""
//    @State var dateInput: Int = 0
    
    @State var week: String = ""
    @State var height: String = ""
    @State var waist: String = ""
    @State var top: String = ""
    @State var bottom: String = ""
    
    @State var edema: String = "Option"
    @State var up: String = "Option"
    @State var ug: String = "Option"
    @State var fhb: String = "Option"
    @State var weight: String = ""
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
                
                Text("Date")
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
                
                Spacer().frame(height: 20)
                
                Text("Mother's Condition")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                VStack {
                    HStack {
                        Text("Pregnancy Weeks: ")
                        TextField("Type", text: $week)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("weeks")
                        Spacer()
                    }.padding(.top, 5)
                    .padding(.horizontal, 10)
                    HStack {
                        Text("Fundal Height: ")
                        TextField("Type", text: $height)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("cm")
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Waist: ")
                        TextField("Type", text: $waist)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("cm")
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Blood Pressure: ")
                        TextField("Top", text: $top)
                            .frame(width: 60)
                            .background(.gray.opacity(0.1))
                        Text(" / ")
                        TextField("Bottom", text: $bottom)
                            .frame(width: 60)
                            .background(.gray.opacity(0.1))
                        Spacer()
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 5)
                }.frame(width: 350)
                    .border(Color.secondary, width: 1)
                
                Spacer().frame(height: 20)
                
                Text("Medical Record")
                    .font(.system(.body, design: .serif))
                    .bold()

                VStack {
                    HStack {
                        Text("Edema: ")
                            .foregroundStyle(.black)
                        Menu {
                            Button(action: {edema = "-"}, label: {
                                Text("-")
                            })
                            Button(action: {edema = "+"}, label: {
                                Text("+")
                            })
                            Button(action: {edema = "⧺"}, label: {
                                Text("⧺")
                            })
                        } label: {
                            if (edema == "Option") {
                                Text(edema)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(edema)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                        Text("Uric Protein: ")
                        Menu {
                            Button(action: {up = "-"}, label: {
                                Text("-")
                            })
                            Button(action: {up = "+"}, label: {
                                Text("+")
                            })
                            Button(action: {up = "⧺"}, label: {
                                Text("⧺")
                            })
                        } label: {
                            if (up == "Option") {
                                Text(up)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(up)
                                    .foregroundStyle(.black)
                            }
                        }
                    }.padding(.top, 5)
                        .padding(.horizontal, 10)
                    
                    HStack {
                        Text("Uric Glucose: ")
                        Menu {
                            Button(action: {ug = "-"}, label: {
                                Text("-")
                            })
                            Button(action: {ug = "+"}, label: {
                                Text("+")
                            })
                            Button(action: {ug = "⧺"}, label: {
                                Text("⧺")
                            })
                        } label: {
                            if (ug == "Option") {
                                Text(ug)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(ug)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                        Text("FHB: ") // Fetal Heart Beat
                        Menu {
                            Button(action: {fhb = "-"}, label: {
                                Text("-")
                            })
                            Button(action: {fhb = "+"}, label: {
                                Text("+")
                            })
                            Button(action: {fhb = "⧺"}, label: {
                                Text("⧺")
                            })
                        } label: {
                            if (fhb == "Option") {
                                Text(fhb)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(fhb)
                                    .foregroundStyle(.black)
                            }
                        }
                    }.padding(.horizontal, 10)
                    
                    HStack {
                        Text("Weight: ")
                        TextField("Type", text: $weight)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("kg")
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    Spacer().frame(height: 10)
                    
                    HStack(alignment: .top) {
                        TextEditor(text: $note)
                            .scrollContentBackground(Visibility.hidden)
                            .background(Color.gray.opacity(0.1))
                            .frame(height: 150)
                            .overlay(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Note")
                                        .foregroundStyle(.gray)
                                        .allowsHitTesting(false)
                                        .padding()
                                }
                            }
                    }.padding(.bottom, 5)
                    .padding(.horizontal, 10)
                }.frame(width: 350)
                    .border(Color.secondary, width: 1)
               
                Spacer().frame(height: 20)
                

                if (wrongInput == true) {
                    Text("Something went wrong.\nPlease review your input.")
                        .font(.body)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                
                Button(action: addNewMotherHealth)
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
    
    func addNewMotherHealth() {
        if((year.isEmpty) == false && (month.isEmpty) == false && (day.isEmpty) == false) {
            if(year.count == 4 && month.count <= 2 && day.count <= 2)
            {
                wrongInput = false
                
                let newObject = MotherHealth(context: newMother)
                
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
                newObject.date = dateInput
                
                // Other
                newObject.weeks = week
                newObject.height = height
                newObject.waist = waist
                newObject.bptop = top
                newObject.bpbottom = bottom
                
                // Dropdown
                if(edema == "Option") {
                    edema = ""
                }
                if(up == "Option") {
                    up = ""
                }
                if(ug == "Option") {
                    ug = ""
                }
                if(fhb == "Option") {
                    fhb = ""
                }
                
                newObject.edema = edema
                newObject.uprotein = up
                newObject.uglucose = ug
                newObject.fhb = fhb
                newObject.weight = weight
                newObject.note = note
                
                do {
                    try newMother.save()
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
    NewMotherView()
}
