//
//  Clue.swift
//  TreasureHunt
//
//  Created by Cam on 2023-11-26.
//

import SwiftUI

class ClueStore: ObservableObject {
	@Published var clues: [Clue]
	let initialClues: [UUID] = [UUID(uuidString: "f33cbbb1-5403-4cd4-881f-f0f83a5d0f88")!, UUID(uuidString: "5a13dc60-4535-41fc-9c36-0b61f8b29325")!]
	let path = "FoundClues.json"
	@Published var foundClues: [UUID]
	
	var availableClues: [Clue] {
		clues.filter { clue in
			foundClues.contains {
				$0 == clue.id
			}
		}
	}
	
	init() {
		clues = Bundle.main.decode("Clues.json")
		let loadedIds =  FileManager.default.loadIds(from: path)
		if !loadedIds.isEmpty {
			_foundClues = Published(wrappedValue: loadedIds)
		} else {
			_foundClues = Published(wrappedValue: initialClues)
		}
	}
	
	func checkID(_ id: UUID) -> Result<Clue, ClueCheckError> {
		if let clue = clues.first(where: {id == $0.id}) {
			if foundClues.contains(where: {$0 == id}){
				return .failure(.alreadyFound)
			}
			foundClues.append(id)
			save()
			return .success(clue)
		}
		return .failure(.invalid)
	}
	
	func clear() {
		foundClues = initialClues
		save()
	}
	
	func load() {
		foundClues = FileManager.default.loadIds(from: path)
	}
	
	func save() {
		FileManager.default.saveIds(foundClues, to: path)
	}
}

struct Clue: Identifiable, Codable, Hashable {
	var id: UUID
	var title: String
	var body: String
	
	var bodyFormatted: LocalizedStringKey {
		LocalizedStringKey(body)
	}
	
	static let example = Clue(id: UUID(uuidString: "f33cbbb1-5403-4cd4-881f-f0f83a5d0f88")!, title: "Clue #0", body: "You need a code for this device  \n*Six digits long, to be precise*  \nThis rhyme contains the clues you need,  \nwithin the next six lines you'll read:\n\nOne-eighth a stack of dirt or stone  \nOne more than being all alone  \nHow many tears that temples hide  \nHow many beasts that Champions ride  \nThe number key with 'ABC'  \nAnd finally, the square of three\n\nWith code in hand the games begin,  \nA prize awaits if you can win")
}

enum ClueCheckError: Error {
	case invalid, alreadyFound
}
