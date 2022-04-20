//
//  GroupPrayNotePreview.swift
//  Moyang
//
//  Created by kibo on 2022/04/20.
//

import SwiftUI

struct GroupPrayNotePreview: View {
    @State private var showingGroupPrayNoteView = false
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("기도 노트")
                    .padding(.leading, 24)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.nightSky1)
                Spacer()
                NavigationLink(destination: GroupPrayNoteView(),
                               isActive: $showingGroupPrayNoteView) {
                    Button(action: {
                        showingGroupPrayNoteView = true
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.nightSky2)
                        
                    }
                }
                               .padding(.trailing, 20)
            }
            .padding(.top, 20)
            Spacer()
        }
        .background(Color.sheep3)
    }
}

struct GroupPrayNotePreview_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayNotePreview()
    }
}
