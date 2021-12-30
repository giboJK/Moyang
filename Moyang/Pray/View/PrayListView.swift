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
            NavigationLink(destination: PrayAddView(vm: PrayAddVM(prayRepo: PrayRepoImpl())),
                           isActive: $newPraySubject) { EmptyView() }
            Text("Add New Pray")
                .foregroundColor(.blue)
            Spacer()
        }
        .navigationBarItems(trailing: Button(action: { newPraySubject.toggle()},
                                             label: {
            Image(systemName: "plus")
                .accessibilityLabel("Adding a new pray")
                .foregroundColor(Color.black)
        }))
        .background(Color(UIColor.sheep))
    }
}

struct PrayListView_Previews: PreviewProvider {
    static var previews: some View {
        PrayListView(vm: PrayListVM(prayRepo: PrayRepoImpl()))
    }
}
