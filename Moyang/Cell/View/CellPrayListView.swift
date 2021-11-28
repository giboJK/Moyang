//
//  CellPrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/21.
//

import SwiftUI

struct CellPrayListView: View {
    @ObservedObject var viewModel: CellPrayListVM
    
    @State private var sortingByName = true
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        sortingByName.toggle()
                    }
                } label: {
                    sortingByName ?
                    Text(Image(uiImage: Asset.Images.Cell.sortDown.image)) + Text("이름순") :
                    Text(Image(uiImage: Asset.Images.Cell.sortDown.image)) + Text("날짜순")
                }
                .foregroundColor(Color(Asset.Colors.Dessert.darkSand200.color))
                .frame(alignment: .leading)
                .padding(.leading, 15)
                Spacer()
            }
            List(viewModel.items, id: \.name) { item in
                VStack {
                    HStack {
                        Text(item.name)
                        Spacer()
                    }
                    HStack {
                        Text(item.pray)
                        Spacer()
                    }
                }.onTapGesture {
                    Log.d("\(item.name)")
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct CellPrayListView_Previews: PreviewProvider {
    static var previews: some View {
        CellPrayListView(viewModel: CellPrayListVM())
    }
}
