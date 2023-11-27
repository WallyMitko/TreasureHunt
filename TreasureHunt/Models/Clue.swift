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
		var loadedIds =  FileManager.default.loadIds(from: path)
		if !loadedIds.isEmpty {
			_foundClues = Published(wrappedValue: loadedIds)
		} else {
			_foundClues = Published(wrappedValue: initialClues)
		}
	}
	
	func checkID(_ id: UUID) -> ClueScanResult {
		if clues.contains(where: {id == $0.id}) {
			if foundClues.contains(where: {$0 == id}){
				return .alreadyFound
			}
			foundClues.append(id)
			save()
			return .valid
		}
		return .invalid
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
}

enum ClueScanResult {
	case invalid, alreadyFound, valid
}
