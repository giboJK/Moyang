//
//  GroupPrayDetailVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayDetailVC: UIViewController, VCType, UITextFieldDelegate {
    typealias VM = GroupPrayDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayDetailVCDelegate?
    private var tagList = [String]()

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.title = "기도제목"
    }
    let updateButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.nightSky2, for: .normal)
        $0.setTitleColor(.ydGreen1, for: .disabled)
    }
    let groupNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let groupChangeButton = MoyangButton(.none).then {
        $0.setTitle("그룹 변경", for: .normal)
        $0.setTitleColor(.nightSky3, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky2
    }
    let prayTextView = UITextView().then {
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
    let isSecretLabel = UILabel().then {
        $0.text = "비공개 기도"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let isSecretCheckBox = CheckBox()
    let prayButton = MoyangButton(.primary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let deleteButton = MoyangButton(.warning).then {
        $0.setTitle("삭제", for: .normal)
    }
    let prayPlusButton = MoyangButton(.secondary).then {
        $0.setTitle("기도문 더하기", for: .normal)
    }
    let prayChangeLabel = UILabel().then {
        $0.text = "기도 변화"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let addChangeButton = MoyangButton(.none).then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.tintColor = .nightSky1
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep3
    }
    let prayAnswerLabel = UILabel().then {
        $0.text = "기도 응답"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let addAnswerButton = MoyangButton(.none).then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.tintColor = .nightSky1
    }
    let deleteConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .ghost).then {
        $0.desc = "정말로 삭제하시겠어요? 삭제한 기도는 복구할 수 없습니다."
        $0.firstButton.setTitle("삭제", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupGroupNameLabel()
        setupGroupChangeButton()
        setupDateLabel()
        setupPrayTextField()
        setupTagInfoLabel()
        setupTagTextField()
        setupTagCollectionView()
        setupIsSecretLabel()
        setupIsSecretCheckBox()
        setupPrayChangeView()
        setupPrayAnswerView()
        setupDeleteButton()
        setupPrayPlusButton()
        setupPrayButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
        setupUpdateButton()
    }
    private func setupUpdateButton() {
        navBar.addSubview(updateButton)
        updateButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupGroupNameLabel() {
        view.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(80)
        }
    }
    private func setupGroupChangeButton() {
        view.addSubview(groupChangeButton)
        groupChangeButton.snp.makeConstraints {
            $0.top.bottom.equalTo(groupNameLabel)
            $0.right.equalToSuperview().inset(16)
        }
    }
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupPrayTextField() {
        view.addSubview(prayTextView)
        prayTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(220)
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
        prayTextView.inputAccessoryView = toolBar
    }
    
    private func setupTagInfoLabel() {
        view.addSubview(tagInfoLabel)
        tagInfoLabel.snp.makeConstraints {
            $0.top.equalTo(prayTextView.snp.bottom).offset(12)
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
    
    private func setupIsSecretLabel() {
        view.addSubview(isSecretLabel)
        isSecretLabel.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
    }
    private func setupIsSecretCheckBox() {
        view.addSubview(isSecretCheckBox)
        isSecretCheckBox.snp.makeConstraints {
            $0.centerY.equalTo(isSecretLabel)
            $0.left.equalTo(isSecretLabel.snp.right).offset(4)
            $0.size.equalTo(18)
        }
    }
    private func setupPrayChangeView() {
        view.addSubview(prayChangeLabel)
        prayChangeLabel.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
        }
        
        view.addSubview(addChangeButton)
        addChangeButton.snp.makeConstraints {
            $0.centerY.equalTo(prayChangeLabel)
            $0.right.equalToSuperview().inset(20)
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(prayChangeLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    private func setupPrayAnswerView() {
        view.addSubview(prayAnswerLabel)
        prayAnswerLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
        
        view.addSubview(addAnswerButton)
        addAnswerButton.snp.makeConstraints {
            $0.centerY.equalTo(prayAnswerLabel)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupPrayPlusButton() {
        view.addSubview(prayPlusButton)
        prayPlusButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func increaseTagCollectionViewHeight(count: Int) {
        let currentHeight = tagCollectionView.bounds.height
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(currentHeight + 8 + 32)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            if self.tagCollectionView.visibleCells.count < count {
                self.increaseTagCollectionViewHeight(count: count)
            }
        }
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
        bineViews()
        bindVM()
    }
    private func bineViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.deleteConfirmPopup)
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setPray: prayTextView.rx.text.asDriver(),
                             updatePray: updateButton.rx.tap.asDriver(),
                             setTag: tagTextField.rx.text.asDriver(),
                             addTag: tagTextField.rx.controlEvent(.editingDidEnd).asDriver(),
                             toggleIsSecret: isSecretCheckBox.rx.tap.asDriver(),
                             deletePray: deleteConfirmPopup.firstButton.rx.tap.asDriver(),
                             didTapPrayPlusAndChangeButton: prayPlusButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.isMyPray
            .drive(onNext: { [weak self] isMyPray in
                guard let self = self else { return }
                self.updateButton.isHidden = !isMyPray
                self.deleteButton.isHidden = !isMyPray
                self.prayPlusButton.isHidden = isMyPray
                self.groupChangeButton.isHidden = !isMyPray
                self.tagInfoLabel.isHidden = !isMyPray
                self.tagTextField.isHidden = !isMyPray
                self.isSecretLabel.isHidden = !isMyPray
                self.isSecretCheckBox.isHidden = !isMyPray
                self.addChangeButton.isHidden = !isMyPray
                self.addAnswerButton.isHidden = !isMyPray
                self.prayTextView.isEditable = isMyPray
                self.tagCollectionView.snp.remakeConstraints {
                    if isMyPray {
                        $0.top.equalTo(self.tagTextField.snp.bottom).offset(12)
                        $0.left.right.equalToSuperview().inset(16)
                        $0.height.equalTo(32)
                    } else {
                        $0.top.equalTo(self.prayTextView.snp.bottom).offset(12)
                        $0.left.right.equalToSuperview().inset(16)
                        $0.height.equalTo(32)
                    }
                }
                self.prayChangeLabel.snp.remakeConstraints {
                    if isMyPray {
                        $0.top.equalTo(self.tagCollectionView.snp.bottom).offset(44)
                        $0.left.equalToSuperview().inset(20)
                    } else {
                        $0.top.equalTo(self.tagCollectionView.snp.bottom).offset(20)
                        $0.left.equalToSuperview().inset(20)
                    }
                }
            }).disposed(by: disposeBag)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.pray
            .distinctUntilChanged()
            .drive(prayTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.newTag
            .drive(tagTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.tagList
            .map { $0.count < 5 }
            .drive(tagTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.tagList
            .map { $0.count >= 5 }
            .drive(onNext: { [weak self] isFullTag in
                self?.tagTextField.backgroundColor = isFullTag ? .sheep3 : .sheep1
            }).disposed(by: disposeBag)
        
        output.tagList
            .drive(onNext: { [weak self] list in
                self?.tagList = list
                self?.tagCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        output.tagList
            .delay(.milliseconds(100))
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                if self.tagCollectionView.visibleCells.count < list.count {
                    self.increaseTagCollectionViewHeight(count: list.count)
                } else {
                    if !self.tagCollectionView.visibleCells.isEmpty {
                        var maxY: CGFloat = 0
                        self.tagCollectionView.visibleCells.forEach { cell in
                            maxY = max(cell.frame.maxY, maxY)
                        }
                        let currentHeight = self.tagCollectionView.bounds.height
                        if currentHeight - maxY > 8 {
                            self.tagCollectionView.snp.updateConstraints {
                                $0.height.equalTo(currentHeight - 8 - 32)
                            }
                        }
                    } else {
                        self.tagCollectionView.snp.updateConstraints {
                            $0.height.equalTo(0)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        output.isSecret
            .drive(isSecretCheckBox.rx.isChecked)
            .disposed(by: disposeBag)
        
        output.changes
            .map { "기도 변화 (\($0.count))" }
            .drive(prayChangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.answers
            .map { "기도 응답 (\($0.count))" }
            .drive(prayAnswerLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updatePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .success, message: "기도 저장 완료", disposeBag: self.disposeBag)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.updatePrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .failure, message: "알 수 없는 문제가 발생하였습니다.", disposeBag: self.disposeBag)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.deletePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.deletePrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.prayPlusAndChangeVM
            .drive(onNext: { [weak self] prayPlusAndChangeVM in
                guard let prayPlusAndChangeVM = prayPlusAndChangeVM else { return }
                self?.showPrayPlusAndChangeVC(prayPlusAndChangeVM: prayPlusAndChangeVM)
            }).disposed(by: disposeBag)
    }
    
    private func showPrayPlusAndChangeVC(prayPlusAndChangeVM: PrayPlusAndChangeVM) {
        let vc = PrayPlusAndChangeVC()
        vc.vm = prayPlusAndChangeVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
}

protocol GroupPrayDetailVCDelegate: AnyObject {

}

extension GroupPrayDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tagList[indexPath.row].width(withConstraintedHeight: 16,
                                                       font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + 24 + buttonWidth, height: 32)
    }
}

extension GroupPrayDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewPrayTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tagList[indexPath.row]
        cell.detailVM = vm
        cell.indexPath = indexPath
        cell.bind()
        
        return cell
    }
}
