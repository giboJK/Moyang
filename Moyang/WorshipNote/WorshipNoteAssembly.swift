//
//  WorshipNoteAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/15.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class WorshipNoteAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - NoteMainVC
        container.register(NoteMainVC.self) { r in
            let vc = NoteMainVC()
            vc.vm = r ~> (WorshipNoteVM.self)
            return vc
        }

        // MARK: - WorshipNote
        container.register(WorshipNoteView.self) { r in
            let v = WorshipNoteView()
            v.vm = r ~> (WorshipNoteVM.self)
            return v
        }
        
        container.register(WorshipNoteVM.self) { r in
            WorshipNoteVM(useCase: (r ~> WorshipNoteUseCase.self))
        }
        
        container.register(WorshipNoteUseCase.self) { r in
            WorshipNoteUseCase(repo: (r ~> WorshipNoteRepo.self))
        }
        
        container.register(WorshipNoteRepo.self) { r in
            NoteController(networkService: (r ~> NetworkServiceProtocol.self))
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
        
        // MARK: - Coordinator
    }
}
