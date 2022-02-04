//
//  GroupPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/09.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct GroupPreviewCard: View {
    @ObservedObject var vm: GroupCardVM
    
    var body: some View {
        VStack {
        }
        .modifier(MainCard())
        .eraseToAnyView()
    }
}

struct GroupPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        GroupPreviewCard(vm: GroupCardVM(preview: GroupPreview(name: "", talkingSubject: "", dateString: "", memberList: [])))
    }
}
