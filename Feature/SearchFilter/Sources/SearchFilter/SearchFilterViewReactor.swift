//
//  SearchFilterViewReactor.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/27.
//

import UIKit

import ReactorKit
import RxSwift

public final class SearchFilterViewReactor: Reactor {
	
	public enum Action {
		case clearData
		case updateExtendedState(SearchFilterExtendedState)
		case fetchPopularSpots
		case didSelectSpot(String?)
		case didTapDecreaseButton
		case didTapIncreaseButton
	}
	
	public enum Mutation {
		case setClearData
		case setExtendedState(SearchFilterExtendedState)
		case setPopularSpots([String])
		case setSelectedSpot(String?)
		case setDecreaseValue
		case setIncreaseValue
	}
	
	public struct State {
		var extendedState: SearchFilterExtendedState
		var popularSpots: [String]
		@Pulse var selectedSpot: String?
		var groupCount: Int
	}
	
	public var initialState: State
	
	public init() {
		self.initialState = State(
			extendedState: .travelSpot,
			popularSpots: [],
			groupCount: 0
		)
	}
	
	public func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .clearData:
			return performClearData()
		case let .updateExtendedState(extenedState):
			return performExtenedState(with: extenedState)
		case .fetchPopularSpots:
			return performPopularSpots()
		case let .didSelectSpot(selectedSpot):
			return performDidSelectedSpot(with: selectedSpot)
		case .didTapDecreaseButton:
			return performDidTapDecreaseButton()
		case .didTapIncreaseButton:
			return performDidTapIncreaseButton()
		}
	}
	
	public func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		
		switch mutation {
		case .setClearData:
			state.groupCount = 0
			state.extendedState = .travelSpot
			state.selectedSpot = nil
		case let .setExtendedState(extendedState):
			state.extendedState = extendedState
		case let .setPopularSpots(popularSpots):
			state.popularSpots = popularSpots
		case let .setSelectedSpot(selectedSpot):
			state.selectedSpot = selectedSpot
		case .setDecreaseValue:
			if state.groupCount > 0 {
				state.groupCount -= 1
			}
		case .setIncreaseValue:
			if state.groupCount < 6 {
				state.groupCount += 1
			}
		}
		
		return state
	}
}

// MARK: - PRIVATE METHOD
private extension SearchFilterViewReactor {
	
	func performClearData() -> Observable<Mutation> {
		return .just(.setClearData)
	}
	
	func performExtenedState(with extendedState: SearchFilterExtendedState) -> Observable<Mutation> {
		return .just(.setExtendedState(extendedState))
	}
	
	// TODO: API FETCH
	func performPopularSpots() -> Observable<Mutation> {
		let popularSpots: Single<[String]> = .just(
			["제주", "속초", "양양", "전주", "부산", "목포", "제주", "속초", "양양", "전주", "부산", "목포"]
		)
		return popularSpots
			.asObservable()
			.map { .setPopularSpots($0) }
	}
	
	func performDidSelectedSpot(with selectedSpot: String?) -> Observable<Mutation> {
		return .just(.setSelectedSpot(selectedSpot))
	}
	
	func performDidTapDecreaseButton() -> Observable<Mutation> {
		return .just(.setDecreaseValue)
	}
	
	func performDidTapIncreaseButton() -> Observable<Mutation> {
		return .just(.setIncreaseValue)
	}
}
