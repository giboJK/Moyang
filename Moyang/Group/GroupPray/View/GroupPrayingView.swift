//
//  GroupPrayingView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/16.
//

import SwiftUI
import AlertToast

struct GroupPrayingView: View {
    @StateObject var vm: GroupPrayingVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.sheep1)
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 24, trailing: 8))
                
                HStack(spacing: 0) {
                    Button {
                        vm.prevPray()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(!vm.isPrevPrayEnable ? .sheep5 : .sheep1)
                    }
                    .disabled(!vm.isPrevPrayEnable)
                    Spacer()
                    
                    Text(vm.title)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.sheep1)
                    
                    Spacer()
                    Button {
                        vm.nextPray()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(!vm.isNextPrayEnable ? .sheep5 : .sheep1)
                    }
                    .disabled(!vm.isNextPrayEnable)
                }
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 20, trailing: 24))
                .frame(width: UIScreen.screenWidth - 48, alignment: .center)
                
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
                .padding(EdgeInsets(top: 28, leading: 28, bottom: 32, trailing: 28))
                
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
                                                   height: 48))
                    .padding(.bottom, 20)
                    .disabled(vm.time < 10)
            }
            .frame(maxWidth: .infinity)
            
            IndicatorView(tintColor: .sheep2, scale: 1.2)
                .hidden(!vm.isLoading)
                .frame(alignment: .center)
        }
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

struct GroupPrayingView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayingView(vm: GroupPrayingVM(groupRepo: GroupRepoMock(),
                                            groupInfo: GroupInfo(id: "",
                                                                 createdDate: "",
                                                                 groupName: "",
                                                                 parentGroup: "",
                                                                 leaderList: [],
                                                                 memberList: []),
                                            title: "정김기보 기도",
                                            pray: "기도\n도도도도도\n기도도도도오오오 기도이오오오 기도는 기도다 기도일세 기도도도돗\n\n 돗도로돗 기돗",
                                            memberID: "randomid",
                                            memberList: []))
    }
}
