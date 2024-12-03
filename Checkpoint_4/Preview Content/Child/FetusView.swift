//
//  FetusView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/11/28.
//

import SwiftUI
import CoreData
import AVKit
import PhotosUI

struct FetusView: View {
    @Environment(\.managedObjectContext) var newFetus
    @Environment(\.presentationMode) var presentation
    
    @State var selectedItem: PhotosPickerItem?
    @State var selectedImage: UIImage?

    @State private var fyear = ""
    @State private var fmonth = ""
    @State private var fday = ""
    @State private var fnote = ""
    @State private var wrongInput = false
    @State private var dataInput = ""
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Home Screen", withExtension: "mov")!)
    
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
                
                HStack {
                    TextField("Year", text: $fyear)
                        .background(.gray.opacity(0.1))
                    Text(" / ")
                    TextField("Month", text: $fmonth)
                        .background(.gray.opacity(0.1))
                    Text(" / ")
                    TextField("Day", text: $fday)
                        .background(.gray.opacity(0.1))
                }.padding(.horizontal, 50)
                
                Spacer().frame(height: 20)
                
                if(selectedImage == nil) {
                    PhotosPicker(selection: $selectedItem) {
                        Text("Add Ultrasound Image")
                            .foregroundStyle(.black)
                            .underline()
                            .frame(width: 300, height: 150)
                            .border(Color.secondary, width:1)
                    }
                    .onChange(of: selectedItem) { item in
                        Task {
                            guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
                            guard let uiImage = UIImage(data: data) else { return }
                            selectedImage = uiImage
                        }
                    }
                } else {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(minWidth: 0, maxWidth: 300, maxHeight: 225)
                    PhotosPicker(selection: $selectedItem) {
                        Text("Change Image")
                            .foregroundStyle(.black)
                            .underline()
                    }
                    .onChange(of: selectedItem) { item in
                        Task {
                            guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
                            guard let uiImage = UIImage(data: data) else { return }
                            selectedImage = uiImage
                        }
                    }
                }
                
                Spacer().frame(height: 20)
                
                TextEditor(text: $fnote)
                    .scrollContentBackground(Visibility.hidden)
                    .background(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 100)
                    .overlay(alignment: .topLeading){
                        if fnote.isEmpty {
                            Text("Note")
                                .foregroundStyle(.gray)
                                .allowsHitTesting(false)
                                .padding()
                        }
                    }
                
                Spacer().frame(height: 20)
                
                Button(action: addFetusImage) {
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
    
    private func addFetusImage() {
        if((fyear.isEmpty) == false && (fmonth.isEmpty) == false && (fday.isEmpty) == false) {
            if(fyear.count == 4 && fmonth.count <= 2 && fday.count <= 2)
            {
                wrongInput = false
                
                let newObject = FetusImage(context: newFetus)
                
                // Date Input
                if (fmonth.count == 1)
                {
                    fmonth = "0" + fmonth
                }
                
                if (fday.count == 1)
                {
                    fday = "0" + fday
                }
                
                dataInput = fyear + "/" + fmonth + "/" + fday
                newObject.date = dataInput
                
                // Other
                let png = selectedImage!.pngData()
                newObject.fimage = png
                
                newObject.note = fnote
                newObject.checked = true
                
                do {
                    try newFetus.save()
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
        FetusView()
}
