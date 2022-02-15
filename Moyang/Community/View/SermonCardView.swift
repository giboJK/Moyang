//
//  SermonCardView.swift
//  Moyang
//
//  Created by kibo on 2022/02/04.
//

import SwiftUI

struct SermonCardView: View {
    @ObservedObject var vm = SermonCardVM()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(vm.item.subtitle)
                    .foregroundColor(.ydGreen1)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.bottom, 8)
                Spacer()
            }
            HStack {
                Text(vm.item.title)
                    .foregroundColor(.ydGreen1)
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .padding(.bottom, 8)
                Spacer()
            }
            HStack {
                Text(vm.item.bible)
                    .foregroundColor(.ydGreen1)
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .padding(.bottom, 12)
                Spacer()
            }
            HStack(spacing: 0) {
                Text(vm.item.pastor)
                    .foregroundColor(.ydGreen1)
                    .font(.system(size: 20, weight: .bold, design: .default))
                Spacer()
                Text(vm.item.date)
                    .foregroundColor(.ydGreen2)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .padding(.trailing, 4)
                Text(vm.item.worshipName)
                    .foregroundColor(.ydGreen2)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .padding(.trailing, 4)
                
            }
        }
        .frame(width: .infinity, height: 177, alignment: .leading)
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
        .background(Color.sheep1)
    }
}

struct SermonCardView_Previews: PreviewProvider {
    static var previews: some View {
        SermonCardView()
    }
}
