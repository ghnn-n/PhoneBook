//
//  ViewController.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//

import UIKit
import SnapKit
import CoreData

// MARK: - ViewController
class MainViewController: UIViewController {
    
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
    
    let phoneBookManager = PhoneBookManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        
        return tableView
    }()
    
}

// MARK: - Lifecycle
extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        phoneBookManager.fetchPhoneBook()
        self.tableView.reloadData()
    }
    
}

// MARK: - Method
extension MainViewController {
    
    // View 세팅 메서드
    private func setupUI() {
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
    
    // 추가 버튼 클릭
    @objc func addButtonTapped(_ sender: UIButton) {
        
        // 추가이기 때문에 수정할 내역이 없음을 알려줌
        AddViewController.willFetch = nil
        self.navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
}

// MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    // 셀 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 수정할 내용을 PhoneBookViewController에 전송하고 navigationController push메서드 사용
        AddViewController.willFetch = phoneBookManager.phoneBook[indexPath.row]
        self.navigationController?.pushViewController(AddViewController(), animated: true)
    }
}

// MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBookManager.phoneBook.count
    }
    
    // 셀 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = phoneBookManager.phoneBook[indexPath.row].name
        cell.numberLabel.text = phoneBookManager.phoneBook[indexPath.row].phoneNumber
        if let imageData = phoneBookManager.phoneBook[indexPath.row].image {
            cell.image.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    
}
