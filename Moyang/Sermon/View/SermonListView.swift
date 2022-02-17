//
//  SermonListView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/16.
//

import SwiftUI

struct SermonListView: View {
    @ObservedObject var vm: SermonListVM
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(vm.itemList.indices, id: \.self) { i in
                        let item = vm.itemList[i]
                        VStack(spacing: 4) {
                            HStack(spacing: 0) {
                                Text("제목")
                                    .frame(width: 56, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                                Text(item.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 8)
                            }
                            HStack(spacing: 0) {
                                Text("부제목")
                                    .frame(width: 56, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                                Text(item.subtitle)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 8)
                            }
                            HStack(spacing: 0) {
                                Text("성경구절")
                                    .frame(width: 56, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                                Text(item.bible)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 8)
                            }
                            HStack(spacing: 0) {
                                Text("예배")
                                    .frame(width: 56, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                                Text(item.worship)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 8)
                            }
                            HStack(spacing: 0) {
                                Text("일시")
                                    .frame(width: 56, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                                Text(item.date)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.nightSky1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 8)
                            }
                            .padding(.bottom, 8)
                        }.padding(.top, 12)
                            .background(Color.sheep1)
                            .cornerRadius(12)
                    }
                }.padding(EdgeInsets(top: 20, leading: 16, bottom: 100, trailing: 16))
            }
            
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                }) {
                    NavigationLink(destination: NavigationLazyView(NewSermonView())) {
                        Image(systemName: "plus")
                    }
                    
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: 80,
                                               height: 50))
                .padding(.bottom, 10)
            }
        }
        .navigationTitle("설교 목록")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct SermonListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SermonListView(vm: SermonListVMMock())
        }
    }
}
