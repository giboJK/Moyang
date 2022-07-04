//
//  PrayWithVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class PrayWithVC: UIViewController, VCType, UITextFieldDelegate {
    typealias VM = PrayWithVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    private var tagList = [String]()

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.title = "같이 기도하기"
        $0.closeButton.isHidden = true
        $0.backButton.isHidden = true
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.appleRed1, for: .normal)
    }
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.nightSky2, for: .normal)
        $0.setTitleColor(.sheep4, for: .disabled)
    }
    let parentPrayLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    let newPrayTextField = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let tagInfoLabel = UILabel().then {
        $0.text = "태그는 5개까지 추가되며 하나당 최대 20자입니다."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep4
        $0.numberOfLines = 0
    }
    let tagTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep3
        $0.layer.cornerRadius = 8
        $0.attributedPlaceholder = NSAttributedString(string: "#태그 추가",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
        $0.textColor = .nightSky1
        $0.returnKeyType = .done
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(NewPrayTagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    deinit {
        Log.i(self)
        vm?.clearNewTag()
    }

    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupNewPrayTextField()
        setupTagInfoLabel()
        setupTagTextField()
        setupTagCollectionView()
    }
    
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    private func setupNewPrayTextField() {
        view.addSubview(newPrayTextField)
        newPrayTextField.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(280)
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.barTintColor = .sheep3
        }
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        newPrayTextField.inputAccessoryView = toolBar
    }
    
    private func setupTagInfoLabel() {
        view.addSubview(tagInfoLabel)
        tagInfoLabel.snp.makeConstraints {
            $0.top.equalTo(newPrayTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupTagTextField() {
        view.addSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(tagInfoLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        tagTextField.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.barTintColor = .sheep3
        }
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: .plain,
                                         target: self,
                                         action: #selector(didTapCancelButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, space], animated: false)
        tagTextField.inputAccessoryView = toolBar
        
    }
    private func setupTagCollectionView() {
        view.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagTextField.resignFirstResponder()
        return true
    }
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    @objc func didTapCancelButton() {
        tagTextField.text?.removeAll()
        view.endEditing(true)
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

extension PrayWithVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tagList[indexPath.row].width(withConstraintedHeight: 16,
                                                       font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + 24 + buttonWidth, height: 32)
    }
}

extension PrayWithVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewPrayTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tagList[indexPath.row]
//        cell.vm = vm
//        cell.indexPath = indexPath
//        cell.bind()
        
        return cell
    }
}
