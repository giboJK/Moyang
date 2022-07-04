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
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .sheep5
    }
    let parentPrayTextField = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.isEditable = false
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(PrayingTagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    let replyTextField = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let replyHintLabel = UILabel().then {
        $0.text = "기도문을 적어보세요."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    deinit {
        Log.i(self)
    }

    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupNameLabel()
        setupDateLabel()
        setupParentPrayTextField()
        setupTagCollectionView()
        setupReplyTextField()
        setupReplyHintLabel()
    }
    
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupParentPrayTextField() {
        view.addSubview(parentPrayTextField)
        parentPrayTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(240)
        }
    }
    private func setupTagCollectionView() {
        view.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(parentPrayTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    private func setupReplyTextField() {
        view.addSubview(replyTextField)
        replyTextField.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(240)
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
        replyTextField.inputAccessoryView = toolBar
    }
    private func setupReplyHintLabel() {
        view.addSubview(replyHintLabel)
        replyHintLabel.snp.makeConstraints {
            $0.left.equalTo(replyTextField).inset(4)
            $0.top.equalTo(replyTextField).inset(8)
        }
    }
    
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setReply: replyTextField.rx.text.asDriver(),
                             saveReply: saveButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.memberName
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.parentPray
            .drive(parentPrayTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.parentTagList
            .drive(onNext: { [weak self] list in
                self?.tagList = list
                self?.tagCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        output.reply
            .map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(replyHintLabel.rx.isHidden)
            .disposed(by: disposeBag)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PrayingTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tagList[indexPath.row]
//        cell.vm = vm
//        cell.indexPath = indexPath
//        cell.bind()
        
        return cell
    }
}
