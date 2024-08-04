//
//  BirthdayViewController.swift
//  RxThreads
//
//  Created by 최민경 on 8/5/24.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    private let nextButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
    
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 8)
    let day = BehaviorRelay(value: 1)
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        bind()
    }
    
    func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: date)
                let birthYear = components.year ?? 0
                
                let currentYear = calendar.component(.year, from: Date())
                let age = currentYear - birthYear
                
                // 나이를 계산하고 유효성 검증
                if age >= 17 {
                    owner.infoLabel.text = "가입 가능한 나이입니다"
                    owner.infoLabel.textColor = .blue
                    owner.nextButton.backgroundColor = .blue
                    owner.nextButton.isEnabled = true
                } else {
                    owner.infoLabel.text = "만 17세 이상만 가입 가능합니다."
                    owner.infoLabel.textColor = .red
                    owner.nextButton.backgroundColor = .lightGray
                    owner.nextButton.isEnabled = false
                }
                
                let component = calendar.dateComponents([.day, .month, .year], from: date)
                owner.year.accept(component.year ?? 0)
                owner.month.accept(component.month ?? 0)
                owner.day.accept(component.day ?? 0)
            }.disposed(by: disposeBag)
        
        year
            .map{ "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .bind(with: self) { owner, value in
                owner.monthLabel.text = "\(value)월"
            }
            .disposed(by: disposeBag)
        
        day
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.dayLabel.text = "\(value)일"
            }
            .disposed(by: disposeBag)
    }

    
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}



