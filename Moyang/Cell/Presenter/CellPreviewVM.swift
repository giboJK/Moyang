//
//  CellPreviewVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class CellPreviewVM: ObservableObject {
    @Published private(set) var state = State.idle
    
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
            
            return CellRepoImpl.fetchCellPreview()
                .map { CellPreviewVM.Preview(cellPreview: $0) }
                .map(Event.onPreviewLoaded)
                .catch { Just(Event.onFailedToLoadPreview($0)) }
                .eraseToAnyPublisher()
        }
    }
}

extension CellPreviewVM {
    enum State {
        case idle
        case loading
        case loaded(CellPreviewVM.Preview)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onPreviewLoaded(CellPreviewVM.Preview)
        case onFailedToLoadPreview(Error)
    }
}

extension CellPreviewVM {
    typealias Identifier = String
    struct Preview {
        let cellName: String
        let talkingSubject: String
        let dateString: String
        let memberList: [CellPreviewVM.Member]
        var previewMemberList: [CellPreviewVM.Member]
        
        init(cellPreview: CellPreview) {
            cellName = cellPreview.cellName
            talkingSubject = cellPreview.talkingSubject
            dateString = cellPreview.dateString
            
            var list = [CellPreviewVM.Member]()
            cellPreview.memberList.forEach { member in
                list.append(CellPreviewVM.Member(id: member.id,
                                                 name: member.name,
                                                 profileURL: member.profileURL))
            }
            memberList = list
            previewMemberList = list[randomPick: 6]
        }
    }
    
    struct Member: Identifiable {
        let id: Identifier
        let name: String
        let profileURL: String
    }
}

extension CellPreviewVM {
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
            case .onFailedToLoadPreview(let error):
                return .error(error)
            case .onPreviewLoaded(let preview):
                return .loaded(preview)
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

extension CellPreviewVM {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
