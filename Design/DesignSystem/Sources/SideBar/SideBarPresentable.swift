//
//  SideBarPresentable.swift
//  DesignSystem
//
//  Created by 구본의 on 2024/03/14.
//

import UIKit

import ResourceKit

import SnapKit
import Then

public protocol SideBarPresentable {
	var parentVC: UIViewController? { get set }
	
	var backgroundView: UIView { get }
	var sideBarView: UIView { get }
	var sideBarViewWidth: CGFloat { get set }
	
	func showSideBar(_ completion: (() -> Void)?)
	func hideSideBar(_ completion: (() -> Void)?)
}

public extension SideBarPresentable where Self: UIViewController {
	func showSideBar(_ completion: (() -> Void)? = nil) {
		guard let parentVC else { return }
		setupInitialConfigure()
		setupInitialLayout(parentVC: parentVC)
		animateToShow(parentVC: parentVC, completion)
	}

	func hideSideBar(_ completion: (() -> Void)? = nil) {
		guard let parentVC else { return }
		animateToHide(parentVC: parentVC, completion)
	}
}

private extension SideBarPresentable where Self: UIViewController {
	
	// MARK: - PROPERTY
	var showAnimationDurationTime: TimeInterval { 0.3 }
	var hideAnimationDurationTime: TimeInterval { 0.3 }
	
	var backgroundViewColor: UIColor { AppTheme.Color.neutral900.withAlphaComponent(0.7) }
	var sideBarViewColor: UIColor { AppTheme.Color.white }
	
	// MARK: - METHOD
	
	/// 공통 View의 속성을 정의합니다.
	func setupInitialConfigure() {
		backgroundView.alpha = 0.0
		backgroundView.backgroundColor = backgroundViewColor
		
		sideBarView.alpha = 0.0
		sideBarView.backgroundColor = sideBarViewColor
	}
	
	/// 공통 View의 기본 레이아웃을 정의합니다.
	func setupInitialLayout(parentVC: UIViewController) {
		parentVC.addChild(self)
		self.didMove(toParent: parentVC)
		
		parentVC.view.addSubview(self.view)
		
		self.view.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		self.view.addSubview(backgroundView)
		self.view.addSubview(sideBarView)
		
		backgroundView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		sideBarView.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview()
			make.leading.equalTo(view.snp.trailing)
			make.width.equalTo(sideBarViewWidth)
		}
		
		self.view.layoutIfNeeded()
	}
	
	/// 사이드바가 생성될 때 애니메이션을 정의합니다.
	func animateToShow(
		parentVC: UIViewController,
		_ completion: (() -> Void)?
	) {
		UIView.animate(
			withDuration: showAnimationDurationTime,
			delay: 0.0,
			options: .curveEaseOut,
			animations: {
				self.backgroundView.alpha = 1.0
				self.sideBarView.alpha = 1.0
				self.sideBarView.snp.updateConstraints { make in
					make.leading.equalTo(self.view.snp.trailing).offset(-self.sideBarViewWidth)
				}
				self.view.layoutIfNeeded()
			}, completion: { _ in
				completion?()
			}
		)
	}
	
	/// 사이드바가 사라질 때 애니메이션을 정의합니다.
	func animateToHide(
		parentVC: UIViewController,
		_ completion: (() -> Void)?
	) {
		UIView.animate(
			withDuration: hideAnimationDurationTime,
			delay: 0.0,
			options: .curveEaseOut,
			animations: {
				self.view.alpha = 0.0
				self.sideBarView.snp.updateConstraints { make in
					make.leading.equalTo(self.view.snp.trailing)
				}
				self.view.layoutIfNeeded()
			}, completion: { [weak self] _ in
				self?.view.removeFromSuperview()
				self?.removeFromParent()
				completion?()
			}
		)
	}
}

