//
//  MonthLabel.swift
//  SearchFilter
//
//  Created by 구본의 on 2024/01/10.
//

import UIKit

import HorizonCalendar

struct MonthLabel: CalendarItemViewRepresentable {
	struct InvariantViewProperties: Hashable {
		let font: UIFont
		let textColor: UIColor
		let backgroundColor: UIColor
	}

	struct Content: Equatable {
		let month: MonthComponents
	}

	static func makeView(
		withInvariantViewProperties invariantViewProperties: InvariantViewProperties
	) -> UILabel {
		let label = UILabel()

		label.backgroundColor = invariantViewProperties.backgroundColor
		label.font = invariantViewProperties.font
		label.textColor = invariantViewProperties.textColor
		label.textAlignment = .left
		
		return label
	}

	static func setContent(_ content: Content, on view: UILabel) {
		view.text = "\(content.month.year)년 \(content.month.month)월"
	}
}
