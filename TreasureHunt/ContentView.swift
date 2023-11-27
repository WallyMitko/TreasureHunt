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
					NavigationLink(value: clue) {
						ClueListEntryView(clue: clue)
					}
				}
				Text("Tap the button in the top right corner to scan QR codes.")
					.foregroundColor(.secondary)
					.frame(maxWidth: 250)
					.padding(.top)
				Spacer()
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
		// Scan a QR code and check if it's a UUID
		let id = UUID(uuidString: "1c494a90-f5e0-4daf-ae97-abc29b7f5879")!
		
		// Check that the UUID is a valid clue ID
		let scanResult = clueStore.checkID(id)
		switch (scanResult) {
		case .failure(let error):
			switch error {
			case .invalid:
				alert("Invalid Clue", message: "The QR code you scanned doesn't match any known clues.")
			case .alreadyFound:
				alert("Already Found", message: "You have already found this clue.")
			}
		case .success(let clue):
			presentedClues.append(clue)
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
