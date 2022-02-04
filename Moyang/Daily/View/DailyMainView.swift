//
//  DailyMainView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct DailyMainView: View {
    var body: some View {
        ZStack {
            Color.sheep1.ignoresSafeArea()
            VStack(spacing: 0) {
                SermonCardView()
                MainCategoryList()
                
            }
            .background(Color.sheep1)
        }
    }
}

struct DailyMainView_Previews: PreviewProvider {
    static var previews: some View {
        DailyMainView()
    }
}
