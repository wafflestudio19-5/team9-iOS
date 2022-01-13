//
//  KakaoLoginViewController.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/07.
//

import RxSwift
import RxGesture

class KakaoLoginViewController<View: KakaoLoginView>: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = View()
    }
    
    var customView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "카카오 계정 연결하기"
        
        bind()
    }

    private func bind() {
        customView.skipButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.changeRootViewController(to: RootTabBarController())
            }.disposed(by: disposeBag)
        
        customView.kakaoLoginButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.requestKakaoLogin()
            }.disposed(by: disposeBag)
    }
}

extension KakaoLoginViewController {
    private func requestKakaoLogin() {
        KakaoAuthManager.requestKakaoLogin(type: .connect)
            .subscribe (onNext: { [weak self] success in
                if success {
                    UserDefaults.standard.setValue(true, forKey: "didLogin")
                    self?.changeRootViewController(to: RootTabBarController())
                } else {
                    self?.alert(title: "카카오 연동 실패", message: "이미 등록된 계정입니다.", action: "확인")
                }
            }).disposed(by: disposeBag)
    }
}
