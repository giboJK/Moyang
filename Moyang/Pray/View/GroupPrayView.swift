//
//  GroupPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/16.
//

import SwiftUI
import AlertToast

struct GroupPrayView: View {
    @StateObject var vm: GroupPrayVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                        .foregroundColor(.sheep1)
                }
                .padding(.leading, 8)
                Spacer()
            }
        .padding(EdgeInsets(top: 12, leading: 0, bottom: 20, trailing: 0))

            Text(vm.title)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(.sheep1)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 20, trailing: 24))
                .frame(width: UIScreen.main.bounds.width - 48, alignment: .center)

            Text(vm.timeString)
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundColor(.sheep1)
                .frame(width: .infinity, alignment: .center)
            
            ScrollView(.vertical, showsIndicators: false) {
                Text(vm.pray)
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .foregroundColor(.sheep1)
                    .frame(width: .infinity, alignment: .topLeading)
            }
            .frame(width: .infinity)
            .padding(EdgeInsets(top: 28, leading: 28, bottom: 40, trailing: 28))
            
            Spacer()
            
            Button {
                vm.togglePlaying()
            } label: {
                if vm.isPlaying {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .foregroundColor(.sheep1)
                } else {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .foregroundColor(.sheep1)
                }
            }
            .padding(.bottom, 16)
            
            Button(action: {
                vm.amen()
            }, label: {
                Text("예수님의 이름으로 기도드립니다")
            })
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: UIScreen.screenWidth - 80,
                                               height: 50))
                .padding(.bottom, 20)
                .disabled(vm.time < 10)
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(vm.title)
        .background(
            LinearGradient(gradient: Gradient(colors: [.nightSky3, .nightSky2]), startPoint: .top, endPoint: .bottom)
        )
        .toast(isPresenting: $vm.isAmenSaved) {
            return AlertToast(type: .complete(.sheep3), title: "아멘 😀")
        }
        .onDisappear {
            vm.stopSong()
        }
        .onReceive(vm.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.dismiss()
            }
        }
    }
}

struct GroupPrayView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayView(vm: GroupPrayVMMock(title: "정김기보 기도",
                                          pray: "기도\n도도도도도\n기도도도도오오오 기도이오오오 기도는 기도다 기도일세 기도도도돗\n\n 돗도로돗 기돗"))
    }
}
