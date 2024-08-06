//
//  PasswordViewModel.swift
//  RxThreads
//
//  Created by 최민경 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tap: ControlEvent<Void>
        let text: ControlProperty<String?>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let validText: Observable<String>
        let validation: Observable<Bool>
    }
    func transform(input: Input) -> Output {
        let validtion = input.text
            .orEmpty
            .map { $0.count >= 8 }
        
        let validText = Observable.just("8자 이상 입력해주세요")
        
        return Output(tap: input.tap, validText: validText, validation: validtion)
    }
}
