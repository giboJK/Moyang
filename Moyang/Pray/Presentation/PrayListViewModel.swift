//
//  PrayListViewModel.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/17.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class PrayListViewModel: ObservableObject {
    @Published private(set) var state = State.idle

    private var disposables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()

    private var prayReposity: PrayRepository

    init(prayRepo: PrayRepository) {
        self.prayReposity = prayRepo
        
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
            
            return PrayRepoImpl.fetchPraySubject()
                .map {
                    return PrayListViewModel.PrayListItem(praySubject: $0)
                }
                .map(Event.onItemLoaded)
                .catch { Just(Event.onFailedToLoadPray($0)) }
                .eraseToAnyPublisher()
        }
    }
}


extension PrayListViewModel {
    enum State {
        case idle
        case loading
        case loaded(PrayListViewModel.PrayListItem)
        case error(Error)
    }

    enum Event {
        case onAppear
        case onItemLoaded(PrayListViewModel.PrayListItem)
        case onFailedToLoadPray(Error)
    }
}


extension PrayListViewModel {
    struct PrayListItem: Identifiable {
        let id: Int
        let subject: String
        let timeString: String

        init(praySubject: PraySubject) {
            id = praySubject.id
            subject = praySubject.subject
            timeString = praySubject.timeString
        }
    }
}

extension PrayListViewModel {
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
            case .onFailedToLoadPray(let error):
                return .error(error)
            case .onItemLoaded(let item):
                return .loaded(item)
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

extension PrayListViewModel {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
