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
            GroupActivityVM(useCase: (r ~> PrayUseCase.self))
        }
        
        // MARK: - GroupNews
        container.register(GroupEventVM.self) { r in
            GroupEventVM(groupUseCase: r ~> (GroupUseCase.self), prayUseCase: r ~> (PrayUseCase.self))
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
        container.register(NewPrayVC.self) { (r, useCase: PrayUseCase) in
            let vc = NewPrayVC()
            vc.vm = r ~> (NewPrayVM.self, argument: useCase)
            return vc
        }
        container.register(NewPrayVM.self) { (_, useCase: PrayUseCase) in
            return NewPrayVM(useCase: useCase)
        }
        
        container.register(NewPrayVM.self) { r in
            return NewPrayVM(useCase: (r ~> PrayUseCase.self))
        }
        
        // MARK: - NewNote
        container.register(NewNoteVC.self) { r in
            let vc = NewNoteVC()
            vc.vm = r ~> (NewNoteVM.self)
            return vc
        }
        container.register(NewNoteVM.self) { r in
            return NewNoteVM(useCase: (r ~> WorshipNoteUseCase.self), bibleUseCasa: (r ~> BibleUseCase.self))
        }
        container.register(WorshipNoteUseCase.self) { r in
            return WorshipNoteUseCase(repo: (r ~> WorshipNoteRepo.self))
        }
        container.register(WorshipNoteRepo.self) { r in
            NoteController(networkService: (r ~> NetworkServiceProtocol.self))
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
        container.register(GroupPrayingVC.self) { (r, useCase: PrayUseCase, groupID: String, userID: String, prayID: String) in
            let vc = GroupPrayingVC()
            let vm = r ~> (GroupPrayingVM.self, arguments: (useCase, groupID, userID))
            vm.prayID = prayID
            vc.vm = vm
            return vc
        }
        
        container.register(GroupPrayingVC.self) { (r, useCase: PrayUseCase, groupID: String) in
            let vc = GroupPrayingVC()
            vc.vm = r ~> (GroupPrayingVM.self, arguments: (useCase, groupID))
            return vc
        }
        
        container.register(GroupPrayingVM.self) { (_, useCase: PrayUseCase, bibleUseCase: BibleUseCase, groupID: String, userID: String) in
            return GroupPrayingVM(useCase: useCase, bibleUseCase: bibleUseCase, groupID: groupID, userID: userID)
        }
        container.register(GroupPrayingVM.self) { (_, useCase: PrayUseCase, bibleUseCase: BibleUseCase, groupID: String) in
            return GroupPrayingVM(useCase: useCase, bibleUseCase: bibleUseCase, groupID: groupID)
        }
        
        // MARK: - Bible
        container.register(BibleUseCase.self) { r in
            return BibleUseCase(repo: (r ~> WorshipNoteRepo.self))
        }
        
        // MARK: - PrayUseCase
        container.register(PrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(PrayUseCase.self) { r in
            PrayUseCase(repo: r ~> (PrayRepo.self))
        }
        
        // MARK: - GroupUseCase
        container.register(GroupRepo.self) { r in
            GroupController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(GroupUseCase.self) { r in
            GroupUseCase(repo: r ~> (GroupRepo.self))
        }
        
        // MARK: - Coordinator
        container.register(GroupActivityCoordinator.self) { _ in
            guard let nav = self.nav else { return GroupActivityCoordinator() }
            let coordinator = GroupActivityCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
