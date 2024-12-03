//
//  NewChildView.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/11/11.
//

import SwiftUI
import CoreData

struct NewChildView: View {
    @Environment(\.managedObjectContext) var newChild
    
    var body: some View {
        ZStack {
            Color.orange
                .ignoresSafeArea()
            VStack {
                Spacer()
            }
        }
    }
    
    func addNewChildHealth() {
        
    }
}

#Preview {
    NewChildView()
}
