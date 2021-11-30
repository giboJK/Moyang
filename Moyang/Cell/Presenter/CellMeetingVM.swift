//
//  CellMeetingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/21.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class CellMeetingVM: ObservableObject {
    @Published private(set) var state = State.idle
    @Published var answerList: [String] = Array(repeating: "", count: 10)
    
    private var disposables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    private var cellRepo: CellRepo
    
    init(cellRepo: CellRepo) {
        self.cellRepo = cellRepo
        
        Publishers.system(initial: state,
                          reduce: Self.reduce,
                          scheduler: RunLoop.main,
                          feedbacks: [
                            Self.whenLoading(),
                            Self.userInput(input: input.eraseToAnyPublisher())
                          ]
        ).assign(to: \.state, on: self)
            .store(in: &disposables)
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return CellRepoImpl.fetchCellInfo()
                .map { CellMeetingVM.CellInfoItem(cellInfo: $0) }
                .map(Event.onCellInfoLoaded)
                .catch { Just(Event.onFailedToLoadCellInfo($0)) }
                .eraseToAnyPublisher()
        }
    }
}

extension CellMeetingVM {
    enum State {
        case idle
        case loading
        case loaded(CellMeetingVM.CellInfoItem)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onCellInfoLoaded(CellMeetingVM.CellInfoItem)
        case onFailedToLoadCellInfo(Error)
    }
}

extension CellMeetingVM {
    typealias Identifier = Int
    struct CellInfoItem {
        let cellName: String
        let talkingSubject: String
        let questionList: [String]
        let dateString: String
        
        init(cellInfo: CellInfo) {
            cellName = cellInfo.cellName
            talkingSubject = cellInfo.talkingSubject
            questionList = cellInfo.questionList
            dateString = cellInfo.dateString
        }
    }
}

extension CellMeetingVM {
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

extension CellMeetingVM {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
