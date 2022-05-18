//
//  SortedPrayEditRow.swift
//  Moyang
//
//  Created by kibo on 2022/04/20.
//

import SwiftUI
import AlertToast

struct SortedPrayEditRow: View {
    @ObservedObject var vm: GroupEditPrayVM
    @State private var showingPray = true
    var prayId: String
    var title: String
    var pray: String
    @State private var showingSheet = false
    @State private var showingError = false
    
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
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.nightSky1)
                    .background(Color.sheep2)
                    .cornerRadius(12)
                    .onTapGesture {
                        if vm.memberID.elementsEqual(UserData.shared.myInfo?.id ?? "") {
                            showingSheet.toggle()
                        } else {
                            showingError.toggle()
                        }
                    }
                    .toast(isPresenting: $showingError) {
                        return AlertToast(type: .error(.appleRed1), title: "다른 사람의 기도는 수정할 수 없어요😢")
                    }
                    .sheet(isPresented: $showingSheet) {
                        NavigationView {
                            PrayEditView(vm: vm, prayId: prayId, title: title)
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle(title)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
