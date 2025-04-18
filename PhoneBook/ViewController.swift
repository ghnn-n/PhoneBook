//
//  ViewController.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//

import UIKit
import SnapKit

// MARK: - ViewController
class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        
        return tableView
    }()
    
}

// MARK: - Lifecycle
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
}

// MARK: - Method
extension ViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        [titleLabel, addButton, tableView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(titleLabel.snp.height)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }
}

// MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate {
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: - TableViewDataSource
extension ViewController: UITableViewDataSource {
    
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // 셀 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = "name"
        cell.numberLabel.text = "010-0000-0000"
        
        return cell
    }
    
    
}

#Preview{ ViewController() }
