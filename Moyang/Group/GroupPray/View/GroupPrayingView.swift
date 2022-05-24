//
//  GroupPrayingView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/16.
//

import SwiftUI
import AlertToast

struct GroupPrayingView: View {
    var body: some View {
        GroupPrayingViewRepresentable()
            .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct GroupPrayingViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GroupPrayingVC {
        let vc = GroupPrayingVC()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GroupPrayingVC, context: Context) {
    }
    
    typealias UIViewControllerType = GroupPrayingVC
}
