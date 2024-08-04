//
//  PhoneViewController.swift
//  RxThreads
//
//  Created by 최민경 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController {
    
    private let PhoneTextField =  {
        let textField = UITextField()
        textField.text = "010"
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 16
//        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let nextButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let descriptionLabel = UILabel()
    
    private let validText = Observable.just("10자 이상 입력해주세요")
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        bind()
    }
    
    private func bind() {
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = PhoneTextField
            .rx
            .text
            .orEmpty
            .map { text in
                let isValidLength = text.count >= 10
                let isNumeric = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))
                return isValidLength && isNumeric
            }
        
        validation.bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .lightGray
            owner.nextButton.backgroundColor = color
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            print("show alert")
        }
        .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(PhoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        PhoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(PhoneTextField.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(PhoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
}



