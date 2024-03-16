//
//  DayLabel.swift
//  SearchFilter
//
//  Created by 구본의 on 2024/01/09.
//

import UIKit

import HorizonCalendar

struct DayLabel: CalendarItemViewRepresentable {
	struct InvariantViewProperties: Hashable {
		let font: UIFont
		let textColor: UIColor
		let backgroundColor: UIColor
	}
	
	struct Content: Equatable {
		let day: DayComponents
	}

	static func makeView(
		withInvariantViewProperties invariantViewProperties: InvariantViewProperties
	) -> UILabel {
		let label = UILabel()

		label.backgroundColor = invariantViewProperties.backgroundColor
		label.font = invariantViewProperties.font
		label.textColor = invariantViewProperties.textColor
		label.textAlignment = .center
		
		return label
	}

	static func setContent(_ content: Content, on view: UILabel) {
		view.text = "\(content.day.day)"
	}
}
