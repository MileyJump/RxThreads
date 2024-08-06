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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        setupUI()
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
            make.centerY.equalTo(addView.snp.centerY)
            make.leading.equalTo(addView.snp.leading).offset(12)
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
        
        
        addView.backgroundColor = .systemGray2
        addView.layer.cornerRadius = 8
        
        addTextField.backgroundColor = .systemGray6
        addTextField.placeholder = "무엇을 구매하실 건가요?"
        
        addButton.setTitle("추가", for: .normal)
        addButton.tintColor = .systemGray5
    }
