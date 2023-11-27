//
//  ClueListEntryView.swift
//  TreasureHunt
//
//  Created by Cam on 2023-11-27.
//

import SwiftUI

struct ClueListEntryView: View {
	let clue: Clue
    var body: some View {
		HStack {
			Text(clue.title)
				.font(.headline)
			Spacer()
			Image(systemName: "chevron.right")
		}
		.padding()
		.background(.thinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
	ClueListEntryView(clue: Clue.example)
}
