//
//  AddNewGroupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI

struct AddNewGroupView: View {
    @StateObject var vm: AddNewGroupVM
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("소속")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 20, leading: 24, bottom: 4, trailing: 24))
            TextField("", text: $vm.division)
                .placeholder(when: vm.division.isEmpty) {
                    Text("소속").foregroundColor(.sheep4)
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .background(Color.sheep1)
                .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                .foregroundColor(.nightSky1)
                .cornerRadius(8)
                .padding(.bottom, 16)
            
            Text("그룹 이름")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 4, trailing: 24))
            
            TextField("", text: $vm.name)
                .placeholder(when: vm.name.isEmpty) {
                    Text("셀 이름").foregroundColor(.sheep4)
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .background(Color.sheep1)
                .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                .foregroundColor(.nightSky1)
                .cornerRadius(8)
                .padding(.bottom, 16)
            
            Text("리더")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 4, trailing: 24))
            Text("구성원")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 4, trailing: 24))
            Spacer()
            
        }
        .navigationTitle("새 그룹 추가")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewGroupView(vm: AddNewGroupVMMock())
        }
    }
}
