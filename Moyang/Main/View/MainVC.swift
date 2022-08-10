//
//  MainVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MainVC: UITabBarController, VCType {
    typealias VM = DummyVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    var todayVC: TodayVC?
    var communityMainVC: CommunityMainVC?
    var profileVC = ProfileVC()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit { Log.i(self) }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        setupUI()
        bind()
    }

    func setupUI() {
        guard let todayVC = todayVC else {
            Log.e("TodayVC init failed"); return
        }
        guard let communityMainVC = communityMainVC else {
            Log.e("CommunityMainVC init failed"); return
        }

        self.setViewControllers([todayVC, communityMainVC, profileVC], animated: false)
        guard let items = tabBar.items else { return }
        let images = [Asset.Images.Tabbar.today.image, Asset.Images.Tabbar.cross.image, UIImage(systemName: "person.crop.circle.fill")] as [UIImage?]
        let titles = ["오늘", "공동체", "내 정보"]
        for i in 0 ..< images.count {
            items[i].image = images[i]
            items[i].title = titles[i]
        }
        tabBar.backgroundColor = .sheep1
    }

    // MARK: - Binding
    func bind() {
        // Do nothing
    }
}
