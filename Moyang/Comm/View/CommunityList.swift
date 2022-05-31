//
//  CommunityList.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/05.
//

import SwiftUI

struct CommunityList: View {
    @StateObject var vm = CommunityListVM()
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("교회")
                    .foregroundColor(.nightSky1)
                    .frame(width: 72, alignment: .leading)
                    .padding(.leading, 28)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                Text(vm.church)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                Spacer()
            }
            .frame(height: 48)
            .background(Color.sheep1)
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("그룹")
                        .foregroundColor(.nightSky1)
                        .frame(width: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                    Spacer()
                }
                .padding(EdgeInsets(top: 15, leading: 28, bottom: 15, trailing: 0))

                List {
                    ForEach(vm.itemList) { groupInfo in
                        CommunityListRow(item: groupInfo)
                    }
                    .listRowBackground(Color.clear)
                }.padding(.leading, 32)
                    .listStyle(.plain)
            }
            .frame(height: .infinity)
            .background(Color.sheep1)
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep3)
        .navigationTitle("공동체")
    }
}

struct CommunityList_Previews: PreviewProvider {
    static var previews: some View {
        CommunityList()
    }
}

struct CommunityListRow: View {
    var item: GroupInfo
    @State private var isShowingGroupView = false
    var body: some View {
        HStack(spacing: 0) {
            Text(item.groupName)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.nightSky1)
            
            Spacer()
            
            NavigationLink(destination: GroupView(vm: GroupVM(groupInfo: item)), isActive: $isShowingGroupView) {
                Button(action: {
                    isShowingGroupView = true
                }) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                }
            }
            .frame(width: 20)
        }
        .frame(height: 48)
    }
}
