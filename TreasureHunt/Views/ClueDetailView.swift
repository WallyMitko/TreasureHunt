//
//  ClueDetailView.swift
//  TreasureHunt
//
//  Created by Cam on 2023-11-28.
//

import SwiftUI

struct ClueDetailView: View {
	let clue: Clue
	@Environment(\.colorScheme) var colorScheme
    var body: some View {
		ScrollView {
			if clue.body.first == "$" {
				if colorScheme == .light {
					Image(clue.body.trimmingCharacters(in: .symbols))
						.resizable()
						.scaledToFit()
				} else {
					Image(clue.body.trimmingCharacters(in: .symbols))
						.resizable()
						.scaledToFit()
						.colorInvert()
				}
					
			}
			else {
				Text(clue.bodyFormatted)
			}
			Spacer()
		}
		.navigationTitle(clue.title)
    }
}

#Preview {
	ClueDetailView(clue: Clue.example)
}
