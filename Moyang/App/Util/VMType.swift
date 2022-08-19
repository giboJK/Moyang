//
//  VMType.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import Foundation
import RxSwift

protocol VMType {
    var disposeBag: DisposeBag { get set }
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class DummyVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    typealias Input = Void
    typealias Output = Void
    init() {}
    
    func transform(input: Void) -> Output { }
}

//import RxSwift
//import RxCocoa
//
//class VM: VMType {
//    var disposeBag: DisposeBag = DisposeBag()
//
//    init() {
//    }
//
//    deinit { Log.i(self) }
//}
//
//extension VM {
//    struct Input {
//
//    }
//
//    struct Output {
//
//    }
//
//    func transform(input: Input) -> Output {
//        return Output()
//    }
//}
