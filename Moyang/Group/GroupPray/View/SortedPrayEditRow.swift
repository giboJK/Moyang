//
//  SortedPrayEditRow.swift
//  Moyang
//
//  Created by kibo on 2022/04/20.
//

import SwiftUI

struct SortedPrayEditRow: View {
    @ObservedObject var vm: GroupEditPrayVM
    @State private var showingPray = true
    var title: String
    var pray: String
    @State private var showingSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                Spacer()
                Button(action: {
                    withAnimation {
                        showingPray.toggle()
                    }
                }, label: {
                    Image(systemName: showingPray ? "chevron.down" : "chevron.up")
                        .font(.system(size: 13, weight: .regular, design: .default))
                })
            }
            
            Divider()
                .frame(height: 0.5)
                .background(Color.sheep2)
                .padding(.bottom, 4)
            
            if showingPray {
                Text(pray)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 8, trailing: 4))
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .frame(minHeight: 72, maxHeight: 300)
                    .frame(maxWidth: .infinity, alignment: .topLeading)    // << here 
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.nightSky1)
                    .background(Color.sheep2)
                    .cornerRadius(12)
                    .onTapGesture {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        NavigationView {
                            PrayEditView(vm: vm, title: title, pray: pray)
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(title)
                    }
            }
        }
        .frame(maxWidth: .infinity)    // << here
    }
}
