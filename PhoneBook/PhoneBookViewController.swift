//
//  AddViewController.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//

import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {
    
    var imageData = Data()
    
    var container = NSPersistentContainer(name: PhoneBook.id)
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
extension PhoneBookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        setupUI()
    }
}

// MARK: - Method
extension PhoneBookViewController {
    
    @objc func randomButtonTapped(_ sender: UIButton) {
        getImage()
    }
    
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let _ = PhoneBookViewController.willFetch {
            updatePhoneBook()
        } else {
            createPhoneBook()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createPhoneBook() {
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.id, in: self.container.viewContext) else { return }
        
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PhoneBook.Key.id, ascending: false)]
        fetchRequest.fetchLimit = 1
        
        if let lastCount = try? self.container.viewContext.fetch(fetchRequest).first {
            newPhoneBook.setValue(lastCount.id + 1, forKey: PhoneBook.Key.id)
        } else {
            newPhoneBook.setValue(1, forKey: PhoneBook.Key.id)
        }
        
        newPhoneBook.setValue(nameTextField.text, forKey: PhoneBook.Key.name)
        newPhoneBook.setValue(numberTextField.text, forKey: PhoneBook.Key.phoneNumber)
        newPhoneBook.setValue(imageData, forKey: PhoneBook.Key.image)
        
        do {
            try self.container.viewContext.save()
        } catch {
            print("저장 실패")
        }
    }
    
    private func updatePhoneBook() {
        guard let fetchPhoneBook = PhoneBookViewController.willFetch else { return }
        
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", fetchPhoneBook.id)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                data.setValue(nameTextField.text, forKey: PhoneBook.Key.name)
                data.setValue(numberTextField.text, forKey: PhoneBook.Key.phoneNumber)
                data.setValue(imageData, forKey: PhoneBook.Key.image)
            }
            
            try self.container.viewContext.save()
            
        } catch {
            print("수정 실패")
        }
    }
    
    private func getImage() {
        let randomNumber = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-form/\(String(randomNumber))") else {
            print("API URL is invalid")
            return
        }

        print("url: \(url)")
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                print("Error code: \(error.localizedDescription)")
             }
            
            guard let data, error == nil else {
                print("Data load failed")
                return
            }
            
            let successRange = 200..<300
            
            guard let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) else {
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
            
            self.imageData = imageData
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
            
        }.resume()
        
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        if let data = PhoneBookViewController.willFetch {
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
