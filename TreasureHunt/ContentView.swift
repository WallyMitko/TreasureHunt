//
//  ContentView.swift
//  TreasureHunt
//
//  Created by Cam on 2023-11-26.
//

import SwiftUI

struct ContentView: View {
	@StateObject var clueStore = ClueStore()
	@State private var showAlert = false
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var presentedClues = [Clue]()
	
    var body: some View {
		NavigationStack(path: $presentedClues) {
			VStack {
				ForEach (clueStore.availableClues) { clue in
					Text(clue.title)
				}
			}
			.navigationDestination(for: Clue.self) { clue in
				Text(clue.bodyFormatted)
			}
			.navigationTitle("Clues")
			.padding()
			.toolbar {
				Button {
					scan()
				} label: {
					Image(systemName: "qrcode.viewfinder")
				}
			}
			.alert(alertTitle, isPresented: $showAlert) {
				Button("OK", role: .cancel) {}
			} message: {
				Text(alertMessage)
			}
        }
    }
	
	func scan() {
		let id = UUID(uuidString: "1c494a90-f5e0-4daf-ae97-abc29b7f5879")!
		let scanResult = clueStore.checkID(id)
		switch (scanResult) {
		case .invalid:
			alert("Invalid ID", message: "The QR code you scanned doesn't match any known clues.")
		case .alreadyFound:
			alert("Already Found", message: "You have already found this clue.")
		case .valid:
			// Go to the newly scanned clue
			alert("Valid Clue", message: "")
		}
	}
	
	func alert(_ title: String, message: String) {
		alertTitle = title
		alertMessage = message
		showAlert = true
	}
}

#Preview {
    ContentView()
}
