//
//  ViewModelType.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
