//
//  ViewController.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        [titleLabel, addButton].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(titleLabel.snp.height)
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
    }
}

#Preview{ ViewController() }
