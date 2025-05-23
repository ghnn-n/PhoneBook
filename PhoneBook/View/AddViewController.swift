//
//  AddViewController.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//

import UIKit
import SnapKit
import CoreData

// MARK: - AddViewController
class AddViewController: UIViewController {
    
    let phoneBookManager = PhoneBookManager()
    
    // URL로 이미지를 불러오면 담아둘 변수
    var imageData = Data()
    
    // ViewController에서 보낼 데이터를 받을 변수
    static var willFetch: PhoneBook?
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 100
        image.layer.masksToBounds = true
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.lightGray.cgColor
        
        return image
    }()
    
    private lazy var randomImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.placeholder = "Name"
        
        return textField
    }()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.placeholder = "Phone Number"
        
        return textField
    }()

}

// MARK: - Lifecycle
extension AddViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Method
extension AddViewController {
    
    // 랜덤 이미지 생성 버튼 클릭
    @objc func randomButtonTapped(_ sender: UIButton) {
        getImage()
    }
    
    // 저장 버튼 클릭
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // ViewController에서 보낸 값이 있을 경우
        if let _ = AddViewController.willFetch {
            
            // 수정 메서드 호출
            phoneBookManager.updatePhoneBook(name: nameTextField.text ?? "", phoneNumber: numberTextField.text ?? "", image: imageData)
            
            
        } else {    // 없을 경우
            
            // 생성 메서드 호출
            phoneBookManager.createPhoneBook(name: nameTextField.text ?? "", phoneNumber: numberTextField.text ?? "", image: imageData)
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // API를 이용해 이미지를 불러오는 메서드
    private func getImage() {
        let randomNumber = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-form/\(String(randomNumber))") else {
            print("API URL is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let data, error == nil else {
                print("Data load failed")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                print("No response")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(PokeImageURL.self, from: data) else {
                print("Decoding failed")
                return
            }
            
            guard let imageURL = URL(string: decodedData.sprites.frontDefault) else {
                print("imageURL failed")
                return
            }
            
            guard let imageData = try? Data(contentsOf: imageURL) else {
                print("imageData failed")
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print("image failed")
                return
            }
            
            // 이미지를 PhoneBook에 저장하기 위해 데이터를 기록
            self.imageData = imageData
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
            
        }.resume()
        
        
    }
    
    
    // View 세팅
    private func setupUI() {
        view.backgroundColor = .white
        
        // ViewController에서 데이터를 보냈을 경우
        if let data = AddViewController.willFetch {
            self.title = "연락처 수정"
            print(data.id)
            
            nameTextField.text = data.name
            numberTextField.text = data.phoneNumber
            
            if let fetchImage = data.image {
                imageView.image = UIImage(data: fetchImage)
                imageData = fetchImage
            }
        } else {
            title = "연락처 추가"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped))
        
        [imageView, randomImageButton, nameTextField, numberTextField]
            .forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        randomImageButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(randomImageButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        numberTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.trailing.height.equalTo(nameTextField)
        }
        
    }

    // 재활용 가능하도록 작성한 버전
    /*
    private func fetchPokemonAPI(url: URL, completion: @escaping (PokeImageURL?) -> Void) {

        let session = URLSession(configuration: .default)

        session.dataTask(with: URLRequest(url: url)) { data, response, error in

            guard let data, error == nil else {
                print("data load failed")
                completion(nil)
                return
            }

            let successRange = 200..<300

            guard let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) else {
                print("response error")
                completion(nil)
                return
            }

            guard let decodedData = try? JSONDecoder().decode(PokeImageURL.self, from: data) else {
                print("decode error")
                completion(nil)
                return
            }

            completion(decodedData)

        }.resume()
    }
    
    private func getImageData() {
        let randomNumber = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-form/" + String(randomNumber)) else {
            print("Invalid URL")
            return
        }

        fetchPokemonAPI(url: url) { [weak self] (result: PokeImageURL?) in

            guard let self, let result else {
                print("not result")
                return
            }

            guard let imageURL = URL(string: result.sprites.frontDefault) else {
                print("imageURL error")
                return
            }

            guard let imageData = try? Data(contentsOf: imageURL) else {
                print("imageData error")
                return
            }

            guard let image = UIImage(data: imageData) else {
                print("image error")
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
     */
    

}
