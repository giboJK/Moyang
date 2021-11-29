//
//  CellPrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/21.
//

import SwiftUI

struct CellPrayListView: View {
    @ObservedObject var viewModel: CellPrayListVM
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        viewModel.changeSorting()
                    }
                } label: {
                    Image(uiImage: Asset.Images.Cell.sortDown.image)
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                    viewModel.showSortingByName ? Text("이름순") : Text("날짜순")
                }
                .foregroundColor(Color(Asset.Colors.Dessert.darkSand200.color))
                .frame(alignment: .leading)
                .padding(.leading, 15)
                Spacer()
            }
            .padding(.top, 10)
            .frame(height: 16, alignment: .leading)
            .foregroundColor(Color(Asset.Colors.Dessert.darkSand200.color))
            if viewModel.showSortingByName {
                List(viewModel.nameSorteditemList, id: \.name) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                    }
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(0 ..< item.prayList.count) { i in
                            HStack {
                                Text(item.dateList[i])
                                Spacer()
                            }
                            HStack {
                                Text(item.prayList[i])
                                Spacer()
                                
                            }
                            Spacer()
                                .frame(height: 10)
                        }
                    }
                    .frame(maxHeight: 160)
                }
                .listStyle(PlainListStyle())
            } else {
                List(viewModel.dateSorteditemList, id: \.date) { item in
                    HStack {
                        Text(item.date)
                        Spacer()
                    }
//                    VStack {
//
//                        HStack {
//                            Text(item.pray)
//                            Spacer()
//                        }
//                    }.onTapGesture {
//                        Log.d("\(item.name)")
//                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct CellPrayListView_Previews: PreviewProvider {
    static var previews: some View {
        CellPrayListView(viewModel: CellPrayListVM())
    }
}
