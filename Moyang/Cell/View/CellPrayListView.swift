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
                    viewModel.changeSorting()
                } label: {
                    Image(uiImage: Asset.Images.Cell.sortDown.image)
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                    viewModel.showSortingByName ? Text("이름순") : Text("날짜순")
                }
                .foregroundColor(Color(Asset.Colors.Dessert.darkSand200.color))
                .padding(.leading, 15)
                Spacer()
            }
            .padding(.top, 10)
            .frame(height: 16, alignment: .leading)
            if viewModel.showSortingByName {
                List(viewModel.nameSorteditemList, id: \.name) { item in
                    HStack {
                        Text(item.name.split(separator: "_").first!)
                        Spacer()
                        Image(systemName: "pencil")
                    }
                    .background(
                        NavigationLink(destination: CellMemberPrayEditView(name: item.name)) {}
                            .opacity(0)
                    )
                    .buttonStyle(PlainButtonStyle())
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(item.prayItemList, id: \.date) { item in
                            CellPrayListRow(info: item.date, pray: item.pray)
                                .padding(.bottom, 10)
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
                        Image(systemName: "pencil")
                    }
                    .background(
                        NavigationLink(destination: CellMemberPrayEditView(name: item.date)) {}
                            .opacity(0)
                    )
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(item.prayItemList, id: \.member) { item in
                            CellPrayListRow(info: item.member, pray: item.pray)
                                .padding(.bottom, 10)
                        }
                    }
                    .frame(maxHeight: 160)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct CellPrayListView_Previews: PreviewProvider {
    static var previews: some View {
        CellPrayListView(viewModel: CellPrayListVM(cellRepo: CellRepoImpl()))
    }
}
