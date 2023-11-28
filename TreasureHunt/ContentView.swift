//
//  ContentView.swift
//  TreasureHunt
//
//  Created by Cam on 2023-11-26.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
	@StateObject var clueStore = ClueStore()
	@State private var showAlert = false
	@State private var showDeletionAlert = false
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var presentedClues = [Clue]()
	@State private var showScanner = false
	@State private var showAlertOnDismiss = false
	
	var body: some View {
		NavigationStack(path: $presentedClues) {
			ScrollView {
				ForEach (clueStore.availableClues) { clue in
					NavigationLink(value: clue) {
						ClueListEntryView(clue: clue)
					}
				}
				Text("Tap the button in the top right corner to scan QR codes.")
					.foregroundColor(.secondary)
					.frame(maxWidth: 250)
					.padding(.top)
				Button("Reset clues", role: .destructive) {
					alertTitle = "Are you sure?"
					alertMessage = "This will completely reset your progress and cannot be undone."
					showDeletionAlert = true
				}
				.buttonStyle(.bordered)
				Spacer()
			}
			.navigationDestination(for: Clue.self) { clue in
				Text(clue.bodyFormatted)
			}
			.navigationTitle("Clues")
			.padding()
			.toolbar {
				ToolbarItem(placement: .topBarTrailing){
					Button {
						showScanner = true
					} label: {
						Image(systemName: "qrcode.viewfinder")
					}
				}
			}
			.alert(alertTitle, isPresented: $showAlert) {
				Button("OK", role: .cancel) { showAlertOnDismiss = false }
			} message: {
				Text(alertMessage)
			}
			.alert(alertTitle, isPresented: $showDeletionAlert) {
				Button("Cancel", role: .cancel) { }
				Button("Reset", role: .destructive) {
					clueStore.clear()
				}
			} message: {
				Text(alertMessage)
			}
			.sheet(isPresented: $showScanner, onDismiss: sheetDismissed) {
				CodeScannerView(codeTypes: [.qr], completion: scan)
			}
		}
	}
	
	func scan(result: Result<ScanResult, ScanError>) {
		showScanner = false
		switch result {
		case .failure(let error):
			alert("Scan Error", message: error.localizedDescription)
		case .success(let data):
			if let scannedId = UUID(uuidString: data.string) {
				let scanResult = clueStore.checkID(scannedId)
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
			else {
				alert("Invalid Code", message: "The code you scanned is not a clue ID.")
			}
		}
		
	}
	
	func alert(_ title: String, message: String) {
		alertTitle = title
		alertMessage = message
		showAlertOnDismiss = true
	}
	
	func sheetDismissed() {
		if showAlertOnDismiss {
			showAlert = true
		}
	}
}

#Preview {
	ContentView()
}
