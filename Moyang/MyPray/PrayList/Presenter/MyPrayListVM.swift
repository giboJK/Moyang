//
//  MyPrayListVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import RxSwift
import RxCocoa

class MyPrayListVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    
    // MARK: - Events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - UI
    
    // MARK: - VM
    let detailVM = BehaviorRelay<MyPrayDetailVM?>(value: nil)
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
        fetechList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        
    }
    
    private func fetechList() {
        
    }
}

extension MyPrayListVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}

extension MyPrayListVM {
    struct PrayListItem {
        // Pray
        let prayID: String?
        let title: String?
        let content: String?
        var latestDate: String?
        let createDate: String?
                
        init(data: MyPray) {
            self.prayID = data.prayID
            self.title = data.title
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
        }
    }
}
