//
//  CellInfoVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/21.
//  Copyright © 2021 정김기보. All rights reserved.
//


import SwiftUI
import Combine

class CellInfoVM: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var disposables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    private var cellRepo: CellRepo
    
    init(cellRepo: CellRepo) {
        self.cellRepo = cellRepo
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension CellInfoVM {
    enum State {
        case idle
        case loading
        case loaded(CellInfoVM.CellInfo)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onCellInfoLoaded(CellInfoVM.CellInfo)
        case onFailedToLoadCellInfo(Error)
    }
}

extension CellInfoVM {
    struct CellInfo {
        let cellName: String
        let talkingSubject: String
        let dateString: String
        
        init(cellPreview: CellPreview) {
            cellName = cellPreview.cellName
            talkingSubject = cellPreview.talkingSubject
            dateString = cellPreview.dateString
        }
    }
}

extension CellInfoVM {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadCellInfo(let error):
                return .error(error)
            case .onCellInfoLoaded(let cellInfo):
                return .loaded(cellInfo)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
}

extension CellInfoVM {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
