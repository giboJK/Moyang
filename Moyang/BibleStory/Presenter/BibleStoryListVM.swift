//
//  BibleStoryListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/29.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class BibleStoryListVM: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var disposables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    private var bibleStoryRepo: BibleStoryRepo
    
    
    init(bibleStoryRepo: BibleStoryRepo) {
        self.bibleStoryRepo = bibleStoryRepo
        
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
            
            return BibleStoryRepoImpl.fetchStoryPreviews()
                .map { previews in
                    if previews.count > 1 {
                        guard let pathOne = Bundle.main.path(forResource: previews[0].imageName, ofType: "jpeg"),
                              let imageOne = UIImage(contentsOfFile: pathOne)
                        else { return [] }
                        guard let pathTwo = Bundle.main.path(forResource: previews[1].imageName, ofType: "jpeg"),
                              let imageTwo = UIImage(contentsOfFile: pathTwo)
                        else { return [] }
                        var itemOne = ListItem(storyPreview: previews[0])
                        itemOne.image = imageOne
                        var itemTwo = ListItem(storyPreview: previews[1])
                        itemTwo.image = imageTwo
                        return [itemOne, itemTwo]
                    }
                    return []
                }
                .map(Event.onListItemLoaded)
                .catch { Just(Event.onFailedToLoadImages($0)) }
                .eraseToAnyPublisher()
        }
    }
}

extension BibleStoryListVM {
    enum State {
        case idle
        case loading
        case loaded([BibleStoryListVM.ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectImage(Int)
        case onListItemLoaded([BibleStoryListVM.ListItem])
        case onFailedToLoadImages(Error)
    }
}

extension BibleStoryListVM {
    struct ListItem: Identifiable {
        let id: Int
        let title: String
        var image: UIImage = UIImage()
        
        init(storyPreview: StoryPreview) {
            id = storyPreview.id
            title = storyPreview.title
        }
    }
}

extension BibleStoryListVM {
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
            case .onListItemLoaded(let listItems):
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

extension BibleStoryListVM {
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input}
    }
}
