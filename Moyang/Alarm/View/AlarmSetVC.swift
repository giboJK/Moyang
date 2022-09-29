//
//  AlarmSetVC.swift
//  Moyang
//
//  Created by kibo on 2022/09/14.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class AlarmSetVC: UIViewController, VCType {
    typealias VM = AlarmSetVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: AlarmSetVCDelegate?

    // MARK: - UI
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let prayLabel = UILabel().then {
        $0.text = "기도"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .sheep1
    }
    let prayAlarmAddButton = UIButton()
    let prayTabel = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(AlarmTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 68
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    let qtLabel = UILabel().then {
        $0.text = "말씀 묵상"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .sheep1
    }
    let qtAlarmAddButton = UIButton()
    let qtTabel = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(AlarmTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 68
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        title = "알람설정"
        view.backgroundColor = .nightSky1
        
        setupScrollView()
        setupPrayLabel()
        setupPrayAlarmAddButton()
        setupPrayTabel()
        setupQtLabel()
        setupQtAlarmAddButton()
        setupQtTabel()
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
    private func setupPrayLabel() {
        scrollView.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupPrayAlarmAddButton() {
        scrollView.addSubview(prayAlarmAddButton)
        prayAlarmAddButton.snp.makeConstraints {
            $0.centerY.equalTo(prayLabel)
            $0.right.equalToSuperview().inset(24)
            $0.size.equalTo(28)
        }
    }
    private func setupPrayTabel() {
        scrollView.addSubview(prayTabel)
        prayTabel.snp.makeConstraints {
            $0.top.equalTo(prayLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
        }
    }
    private func setupQtLabel() {
        scrollView.addSubview(qtLabel)
        qtLabel.snp.makeConstraints {
            $0.top.equalTo(prayTabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupQtAlarmAddButton() {
        scrollView.addSubview(qtAlarmAddButton)
        qtAlarmAddButton.snp.makeConstraints {
            $0.centerY.equalTo(qtLabel)
            $0.right.equalToSuperview().inset(24)
            $0.size.equalTo(28)
        }
    }
    private func setupQtTabel() {
        scrollView.addSubview(qtTabel)
        qtTabel.snp.makeConstraints {
            $0.top.equalTo(qtLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bineViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.prayTimeList
            .drive(prayTabel.rx
                .items(cellIdentifier: "cell", cellType: AlarmTVCell.self)) { (_, item, cell) in
                    cell.noAlarmLabel.isHidden = !item.isEmpty
                    cell.timeLabel.isHidden = item.isEmpty
                    cell.ampmLabel.isHidden = item.isEmpty
                    cell.descLabel.isHidden = item.isEmpty
                    cell.alarmSwitch.isHidden = item.isEmpty
                    
                    cell.timeLabel.text = item.time
                    cell.descLabel.text = item.desc
                    cell.alarmSwitch.isOn = item.isOn
                }.disposed(by: disposeBag)
        
        output.qtTimeList
            .drive(qtTabel.rx
                .items(cellIdentifier: "cell", cellType: AlarmTVCell.self)) { (_, item, cell) in
                    cell.noAlarmLabel.isHidden = !item.isEmpty
                    cell.timeLabel.isHidden = item.isEmpty
                    cell.ampmLabel.isHidden = item.isEmpty
                    cell.descLabel.isHidden = item.isEmpty
                    cell.alarmSwitch.isHidden = item.isEmpty
                    
                    cell.timeLabel.text = item.time
                    cell.descLabel.text = item.desc
                    cell.alarmSwitch.isOn = item.isOn
                }.disposed(by: disposeBag)
    }
}

protocol AlarmSetVCDelegate: AnyObject {

}
