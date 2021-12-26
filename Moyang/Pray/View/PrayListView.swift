//
//  PrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayListView: View {
    @ObservedObject var vm: PrayListVM
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newPraySubject = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: PrayAddView(vm: PrayAddVM()), isActive: $newPraySubject) { EmptyView() }
            
            
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
        .background(Color(UIColor.sheep))
        .onAppear {
            vm.fetchPrayList()
        }
    }
    
    private func addPray() {
        let praySubject = PraySubject(id: "asdb12313312",
                                      subject: "ddkdkkd",
                                      timeString: Date().toString(),
                                      prayDayList: ["mon", "wed", "sat"],
                                      prayTime: "08:30 pm")
        vm.add(praySubject)
        presentationMode.wrappedValue.dismiss()
    }
}

struct PrayListView_Previews: PreviewProvider {
    static var previews: some View {
        PrayListView(vm: PrayListVM(prayRepo: PrayRepoImpl()))
    }
}
