//
//  BabyConditionView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/22.
//

import SwiftUI
import CoreData
import AVKit

struct BabyConditionView: View {
    @Environment(\.managedObjectContext) var newBabyData
    @Environment(\.presentationMode) var presentation
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
    @State var year = ""
    @State var month = ""
    @State var day = ""
    @State var weight = ""
    @State var height = ""
    @State var chest = ""
    @State var head = ""
    @State var hour = ""
    @State var milk = "Select"
    @State var test = "Select"
    @State var note = ""
    @State var checked: Bool = false
    @State var dataInput = "0000/00/00"
    @State var wrongInput = false
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    
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
                
                Text("Birthday")
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

                Text("Baby's Condition")
                    .font(.system(.body, design: .serif))
                    .bold()
                
                VStack {
                    HStack {
                        Text("Weight: ")
                        TextField("Type", text: $weight)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("g")
                        Spacer()
                    }.padding(.top, 5)
                    .padding(.horizontal, 10)
                    HStack {
                        Text("Height: ")
                        TextField("Type", text: $height)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("cm")
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Chest Measurement: ")
                        TextField("Type", text: $chest)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("cm")
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Head Circumference: ")
                        TextField("Type", text: $head)
                            .frame(width: 55)
                            .background(.gray.opacity(0.1))
                        Text("cm")
                        Spacer()
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 5)
                }.frame(width: 350)
                    .border(Color.secondary, width: 1)

                Spacer().frame(height: 20)
                
                VStack {
                    HStack {
                        Text("Fed the baby ")
                        Menu {
                            Button(action: {milk = "breast milk"}, label: {Text("breast milk")})
                            Button(action: {milk = "formula milk"}, label: {Text("formula milk")})
                        } label: {
                            if(milk == "Select") {
                                Text(milk)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(milk)
                                    .foregroundStyle(.black)
                            }
                        }
                        Text("for the")
                        Spacer()
                    }.padding(.top, 5)
                        .padding(.horizontal, 10)
                    HStack {
                        Text("first time ")
                        TextField("Type", text: $hour)
                            .frame(width: 40)
                        Text("hours after")
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("the birth.")
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    Text("")
                        .frame(height: 10)
                    
                    HStack {
                        Text("Took tests for congenital ")
                        Spacer()
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("diseases: ")
                        Menu {
                            Button(action: {test = "Yes"}, label: {Text("Yes")})
                            Button(action: {test = "No"}, label: {Text("No")})
                        } label: {
                            if(test == "Select") {
                                Text(test)
                                    .foregroundStyle(.gray)
                            }
                            else {
                                Text(test)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 10)
                    Text("")
                        .frame(height: 10)
                    
                    HStack(alignment: .top) {
                        TextEditor(text: $note)
                            .scrollContentBackground(Visibility.hidden)
                            .background(Color.gray.opacity(0.1))
                            .frame(height: 150)
                            .overlay(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Note:\nYou can write anything here:\n- How you are feeling\n- What you are worried about\n- Things you would like to talk with your doctor")
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
                
                Button(action: addRecord) {
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
    
    func addRecord() {
        if((year.isEmpty) == false && (month.isEmpty) == false && (day.isEmpty) == false) {
            if(year.count == 4 && month.count <= 2 && day.count <= 2)
            {
                wrongInput = false
                
                let newBaby = DeliveryBaby(context: newBabyData)
                
                // Date Input
                if (month.count == 1)
                {
                    month = "0" + month
                }
                
                if (day.count == 1)
                {
                    day = "0" + day
                }
                
                dataInput = year + "/" + month + "/" + day
                newBaby.birthday = dataInput
        
                newBaby.weight = weight
                newBaby.height = height
                newBaby.chest = chest
                newBaby.head = head
                newBaby.hour = hour
                newBaby.milk = milk
                newBaby.test = test
                newBaby.note = note
                
                checked = true
                newBaby.checked = checked
        
                do {
                    try newBabyData.save()
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
    BabyConditionView()
}
