//
//  ShoppingViewModel.swift
//  RxThreads
//
//  Created by 최민경 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    let disposeBag = DisposeBag()
    
    // 초기 쇼핑 리스트
    private var shoppingList = [
        "그린톡 구매하기",
        "사이다 구매",
        "아이패드 케이스 최저가 알아보기",
        "양말 구매하기",
        "참치캔 구매하기",
        "RxSwift 잘하는 법 책 구매하기"
    ]
    
    
    
    struct Input {
        let addButtonTap: ControlEvent<Void>
        let addText: ControlProperty<String>
    }
    
    struct Output {
        let shoppingList: Observable<[String]> // 테이블뷰 데이터
    }
    
    func transform(input: Input) -> Output {
        lazy var shoppingList = BehaviorSubject(value: shoppingList)
        
        // 버튼 클릭 이벤트 처리
        input.addButtonTap
            .withLatestFrom(input.addText) // 버튼 클릭 시 텍스트 필드의 값을 가져옴
            .filter { !$0.isEmpty } // 텍스트가 비어있지 않은 경우만 처리
            .subscribe(with: self) { owner, value in
                owner.shoppingList.append(value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            shoppingList: shoppingList)
        
    }
}
