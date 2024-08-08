//
//  ShoppingViewController.swift
//  RxThreads
//
//  Created by 최민경 on 8/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingViewController: UIViewController {
    private let addView = UIView()
    private let addTextField = UITextField()
    private let addButton = UIButton(configuration: .filled())
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ShoppingViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        setupUI()
        bind()
    }
    
    func bind() {
        let input = ShoppingViewModel.Input(addButtonTap: addButton.rx.tap, addText: addTextField.rx.text.orEmpty, checkButtonTap: tableView.rx.itemSelected.map { $0.row } )
        let output = viewModel.transform(input: input)
        
        output.shoppingList
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) {
                (row, element, cell) in
                cell.listLabel.text = element
                
                output.checkedItems
                    .map { $0[row] ?? false }
                    .bind(to: cell.checkButton.rx.isSelected)
                    .disposed(by: disposeBag)
                
                cell.checkButton.rx.tap
                    .map { row }
                    .bind(to: input.checkButtonTap)
                    .disposed(by: disposeBag)
                
                // 체크 상태에 따라 버튼 이미지 설정
                output.checkedItems
                    .map { $0[row] ?? false }
                    .subscribe(onNext: { isChecked in
                        let imageName = isChecked ? "checkmark.square.fill" : "checkmark.square"
                        cell.checkButton.setImage(UIImage(systemName: imageName), for: .normal)
                    })
                    .disposed(by: disposeBag)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func configureHierarchy() {
        view.addSubview(addView)
        addView.addSubview(addTextField)
        addView.addSubview(addButton)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        addView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(56)
        }
        
        addTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.equalTo(addView).offset(10)
            make.centerY.equalTo(addView)
            make.trailing.equalTo(addButton.snp.leading).inset(-10)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(addView.snp.centerY)
            make.trailing.equalTo(addView.snp.trailing).inset(12)
            make.leading.greaterThanOrEqualTo(addTextField.snp.trailing).offset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupUI() {
        
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.rowHeight = 80
        
        
        view.backgroundColor = .white
        tableView.backgroundColor = .blue
        
        addView.backgroundColor = .systemGray6
        addView.layer.cornerRadius = 8
        
        addTextField.backgroundColor = .systemGray6
        addTextField.placeholder = "무엇을 구매하실 건가요?"
        
        addButton.setTitle("추가", for: .normal)
        addButton.tintColor = .systemGray5
        addButton.setTitleColor(.black, for: .normal)
    }
}
