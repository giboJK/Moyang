//
//  SermonCard.swift
//  Moyang
//
//  Created by kibo on 2022/02/04.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SermonCard: UIView {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: CommunityMainVM?
    
    // MARK: - UI
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)

    lazy var newsButton = UIButton().then {
        $0.setImage(UIImage(systemName: "bell", withConfiguration: largeConfig), for: .normal)
        $0.tintColor = .sheep1
    }
    lazy var sermonCalendarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "calendar", withConfiguration: largeConfig), for: .normal)
        $0.tintColor = .sheep1
    }
    let subTitleLabel = UILabel().then {
        $0.text = "Post Easter, Post Corona (7)"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .sheep1
    }
    let titleLabel = UILabel().then {
        $0.text = "내게 능력을 주시는 하나님"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .sheep1
    }
    let bibleLabel = UILabel().then {
        $0.text = "출애굽기 15:1-2 • 빌립보서 4:11-12"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .sheep1
    }
    let pastorLabel = UILabel().then {
        $0.text = "김주용 위임목사"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .sheep1
    }
    let dateLabel = UILabel().then {
        $0.text = "2022.06.12"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
        $0.textAlignment = .right
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = .nightSky3
        setupNewsButton()
        setupSermonCalendarButton()
        setupSubTitleLabel()
        setupTitleLabel()
        setupBibleLabel()
        setupPastorLabel()
        setupDateLabel()
        
    }
    private func setupNewsButton() {
        addSubview(newsButton)
        newsButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 8)
            $0.right.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
    }
    private func setupSermonCalendarButton() {
        addSubview(sermonCalendarButton)
        sermonCalendarButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 8)
            $0.right.equalTo(newsButton.snp.left).offset(-12)
            $0.size.equalTo(24)
        }
    }
    private func setupSubTitleLabel() {
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 40)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 72)
            $0.left.right.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(40)
        }
    }
    private func setupBibleLabel() {
        addSubview(bibleLabel)
        bibleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 128)
            $0.left.right.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(40)
        }
    }
    private func setupPastorLabel() {
        addSubview(pastorLabel)
        pastorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 156)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(160)
        }
    }
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIApplication.statusBarHeight + 156)
            $0.left.equalToSuperview().inset(260)
            $0.right.equalToSuperview().inset(24)
        }
    }
}
