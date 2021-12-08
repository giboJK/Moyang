//
//  PrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayListView: View {
    @ObservedObject var viewModel: PrayListViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editingPraySubject = false
    @State private var newPraySubject = false
    @State private var isAlarmOn = true
    @State private var praySubject: String =
"""
나를 지으신 하나님. 오직 하나님만 경외하게 하소서.
기도 제목 감사감사 감사감사 감사감사 감사감사
"""
    var body: some View {
        VStack {
            NavigationLink(destination: PrayAddView(), isActive: $editingPraySubject) { EmptyView() }
            NavigationLink(destination: PrayAddView(), isActive: $newPraySubject) { EmptyView() }
            
            HStack {
                Spacer()
                Button(action: {
                    editingPraySubject.toggle()
                }, label: {
                    Image(systemName: "pencil")
                        .accessibilityLabel("Editing selected pray")
                        .foregroundColor(Color.black)
                        .padding(.trailing, 20)
                })
            }
            
            Button(action: addPray) {
                Text("Add New Card")
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .navigationBarItems(trailing: Button(action: { newPraySubject.toggle()},
                                             label: {
            Image(systemName: "plus")
                .accessibilityLabel("Adding a new pray")
                .foregroundColor(Color.black)
        }))
        .padding(.top, 34)
        .background(Color(UIColor.sheep))
    }
    
    
    private func addPray() {
        // 1
        let card = PraySubject(id: 12313312, subject: "ddkdkkd", timeString: Date().toString())
        // 2
        viewModel.add(card)
        // 3
        presentationMode.wrappedValue.dismiss()
    }
}

struct PrayListView_Previews: PreviewProvider {
    static var previews: some View {
        PrayListView(viewModel: PrayListViewModel(prayRepo: PrayRepoImpl()))
    }
}
