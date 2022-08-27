//
//  IndicatorView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/12.
//

import SwiftUI

struct IndicatorView: View {
    var tintColor: Color = .wilderness1
    var scale: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scale, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
