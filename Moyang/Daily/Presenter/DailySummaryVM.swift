//
//  DailySummaryVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/07.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class DailySummaryVM: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var disposables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
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
            
            var calendar = Calendar.autoupdatingCurrent
            calendar.firstWeekday = 1 // Start on Sonday (or 2 for Monday)
            let today = calendar.startOfDay(for: Date())
            var listItem = [ListItem]()
            if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
                for i in 0...6 {
                    if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                        listItem.append(DailySummaryVM.ListItem(id: i, date: day))
                    }
                }
            }
            
            return Just(Event.onDataLoaded(listItem))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

extension DailySummaryVM {
    enum State {
        case idle
        case loading
        case loaded([DailySummaryVM.ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onDataLoaded([DailySummaryVM.ListItem])
        case onFailedToLoadData(Error)
    }
}

extension DailySummaryVM {
    struct ListItem: Identifiable {
        let id: Int
        let date: Date
        
        init(id: Int, date: Date) {
            self.id = id
            self.date = date
        }
    }
}

extension DailySummaryVM {
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
            case .onFailedToLoadData(let error):
                return .error(error)
            case .onDataLoaded(let listItems):
                return .loaded(listItems)
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

extension DailySummaryVM {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
