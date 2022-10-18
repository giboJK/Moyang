//
//  GroupActivityAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class GroupActivityAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(GroupActivityVC.self) { r in
            let vc = GroupActivityVC()
            vc.vm = (r ~> GroupActivityVM.self)
            vc.coordinator = r ~> (GroupActivityCoordinator.self)
            
            // View controllers
            
            let myPrayMainVC = r ~> (MyPrayMainVC.self)
            myPrayMainVC.coordinator = r ~> (MyPrayCoordinator.self)
            vc.myPrayMainVC = myPrayMainVC
            
            vc.worshipNoteView = r ~> (WorshipNoteView.self)
            return vc
        }
        
        container.register(GroupPrayingVC.self) { (_, vm: GroupPrayingVM) in
            let vc = GroupPrayingVC()
            vc.vm = vm
            return vc
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - GroupPray
        container.register(GroupActivityVM.self) { r in
            GroupActivityVM(useCase: (r ~> MyPrayUseCase.self), bibleUseCase: (r ~> BibleUseCase.self))
        }
        
        // MARK: - GroupNews
        container.register(GroupEventVM.self) { r in
            GroupEventVM(groupUseCase: r ~> (GroupUseCase.self), prayUseCase: r ~> (MyPrayUseCase.self))
        }
        container.register(GroupEventVC.self) { r in
            let vc = GroupEventVC()
            vc.vm = r ~> (GroupEventVM.self)
            return vc
        }
        
        
        // MARK: - GroupInfo
        container.register(GroupInfoVM.self) { _ in
            GroupInfoVM()
        }
        
        container.register(GroupInfoVC.self) { r in
            let vc = GroupInfoVC()
            vc.vm = r ~> (GroupInfoVM.self)
            return vc
        }
        
        // MARK: - NewPrayVC
        container.register(NewPrayVC.self) { (r, useCase: MyPrayUseCase) in
            let vc = NewPrayVC()
            vc.vm = r ~> (NewPrayVM.self, argument: useCase)
            return vc
        }
        container.register(NewPrayVM.self) { (_, useCase: MyPrayUseCase) in
            return NewPrayVM(useCase: useCase)
        }
        
        container.register(NewPrayVM.self) { r in
            return NewPrayVM(useCase: (r ~> MyPrayUseCase.self))
        }
        
        // MARK: - NewQTVC
        container.register(NewQTVC.self) { r in
            let vc = NewQTVC()
            vc.vm = r ~> (NewQTVM.self)
            return vc
        }
        container.register(NewQTVM.self) { _ in
            return NewQTVM()
        }
        
        // MARK: - GroupPrayingVC
        container.register(GroupPrayingVC.self) { (r, useCase: MyPrayUseCase, groupID: String, userID: String, prayID: String) in
            let vc = GroupPrayingVC()
            let vm = r ~> (GroupPrayingVM.self, arguments: (useCase, groupID, userID))
            vm.prayID = prayID
            vc.vm = vm
            return vc
        }
        
        container.register(GroupPrayingVC.self) { (r, useCase: MyPrayUseCase, groupID: String) in
            let vc = GroupPrayingVC()
            vc.vm = r ~> (GroupPrayingVM.self, arguments: (useCase, groupID))
            return vc
        }
        
        container.register(GroupPrayingVM.self) { (_, useCase: MyPrayUseCase, bibleUseCase: BibleUseCase, groupID: String, userID: String) in
            return GroupPrayingVM(useCase: useCase, bibleUseCase: bibleUseCase, groupID: groupID, userID: userID)
        }
        container.register(GroupPrayingVM.self) { (_, useCase: MyPrayUseCase, bibleUseCase: BibleUseCase, groupID: String) in
            return GroupPrayingVM(useCase: useCase, bibleUseCase: bibleUseCase, groupID: groupID)
        }
        
        container.register(GroupPrayingVM.self) { (r, useCase: MyPrayUseCase, groupID: String, userID: String) in
            return GroupPrayingVM(useCase: useCase, bibleUseCase: r ~> (BibleUseCase.self), groupID: groupID)
        }
        
        container.register(BibleUseCase.self) { r in
            return BibleUseCase(repo: (r ~> WorshipNoteRepo.self))
        }
        
        container.register(WorshipNoteRepo.self) { r in
            NoteController(networkService: (r ~> NetworkServiceProtocol.self))
        }
        
        
        // MARK: - PrayUseCase
        container.register(MyPrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(MyPrayUseCase.self) { r in
            MyPrayUseCase(repo: r ~> (MyPrayRepo.self))
        }
        
        // MARK: - GroupUseCase
        container.register(GroupRepo.self) { r in
            GroupController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(GroupUseCase.self) { r in
            GroupUseCase(repo: r ~> (GroupRepo.self))
        }
        
        // MARK: - Assembly
        container.register(WorshipNoteAssembly.self) { _ in
            let assembly = WorshipNoteAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(BibleAssembly.self) { _ in
            let assembly = BibleAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(MyPrayAssembly.self) { _ in
            let assembly = MyPrayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        // MARK: - Coordinator
        container.register(GroupActivityCoordinator.self) { r in
            guard let nav = self.nav else { return GroupActivityCoordinator() }
            let note = r ~> (WorshipNoteAssembly.self)
            let bible = r ~> (BibleAssembly.self)
            let myPray = r ~> (MyPrayAssembly.self)
            let coordinator = GroupActivityCoordinator(nav: nav, assembler: Assembler([self, note, bible, myPray]))
            return coordinator
        }
    }
}
