//
//  FileManager-DocumentsDirectory.swift
//  TreasureHunt
//
//  Created by Cam on 2023-11-27.
//

import Foundation

extension FileManager {
	static var documentsDirectory: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	func loadIds(from path: String) -> [UUID] {
		if let data = try? Data(contentsOf: Self.documentsDirectory.appendingPathComponent(path)) {
			if let decoded = try? JSONDecoder().decode([UUID].self, from: data) {
				return decoded
			}
		}
		return [UUID]()
	}
	
	func saveIds(_ ids: [UUID], to path: String) {
		if let encoded = try? JSONEncoder().encode(ids) {
			try? encoded.write(to: Self.documentsDirectory.appendingPathComponent(path))
		}
	}
}
