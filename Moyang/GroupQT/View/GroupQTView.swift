//
//  GroupQTView.swift
//  Moyang
//
//  Created by kibo on 2022/09/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupQTView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    let addVerseButton = MoyangButton(.none).then {
        $0.setTitle("성경구절 추가", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(.sheep2, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep2
    }
    let godCharacterLabel = UILabel().then {
        $0.text = "하나님의 성품 적기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let godCharacterTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let myCharacterLabel = UILabel().then {
        $0.text = "나의 모습 적기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let myCharacterTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let howToLabel = UILabel().then {
        $0.text = "삶에서의 적용점 적기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let howToTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let saveButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("저장하기", attributes: container)
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    // MARK: - UI
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupScrollView()
        setupAddVerseButton()
        setupGodCharacterLabel()
        setupGodCharacterTextView()
        setupMyCharacterLabel()
        setupMyCharacterTextView()
        setupHowToLabel()
        setupHowToTextView()
        setupSaveButton()
    }
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
    private func setupAddVerseButton() {
        container.addSubview(addVerseButton)
        addVerseButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(20)
        }
    }
    private func setupGodCharacterLabel() {
        container.addSubview(godCharacterLabel)
        godCharacterLabel.snp.makeConstraints {
            $0.top.equalTo(addVerseButton.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupGodCharacterTextView() {
        container.addSubview(godCharacterTextView)
        godCharacterTextView.snp.makeConstraints {
            $0.top.equalTo(godCharacterLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
    }
    private func setupMyCharacterLabel() {
        container.addSubview(myCharacterLabel)
        myCharacterLabel.snp.makeConstraints {
            $0.top.equalTo(godCharacterTextView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupMyCharacterTextView() {
        container.addSubview(myCharacterTextView)
        myCharacterTextView.snp.makeConstraints {
            $0.top.equalTo(myCharacterLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
    }
    private func setupHowToLabel() {
        container.addSubview(howToLabel)
        howToLabel.snp.makeConstraints {
            $0.top.equalTo(myCharacterTextView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupHowToTextView() {
        container.addSubview(howToTextView)
        howToTextView.snp.makeConstraints {
            $0.top.equalTo(howToLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
    }
    private func setupSaveButton() {
        container.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(howToTextView.snp.bottom).offset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(88)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind() {
        bineViews()
        bindVM()
    }
    private func bineViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(showBibleSelect: addVerseButton.rx.tap.asDriver())
            
        let _ = vm.transform(input: input)
    }
}
