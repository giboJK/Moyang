//
//  BibleStoryItemVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/05.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class BibleStoryItemVM: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var disposables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    private var bibleStoryRepository: BibleStoryRepo
    
    
    init(bibleStoryRepository: BibleStoryRepo) {
        self.bibleStoryRepository = bibleStoryRepository
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension BibleStoryItemVM {
    enum State {
        case idle
        case loading
        case loaded(UIImage)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoaded(UIImage)
        case onFailedToLoadImages(Error)
    }
}

extension BibleStoryItemVM {
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
            case .onFailedToLoadImages(let error):
                return .error(error)
            case .onLoaded(let image):
                return .loaded(image)
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

extension BibleStoryItemVM {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
