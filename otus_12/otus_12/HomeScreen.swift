import SwiftUI
import Foundation
import Combine

enum SegmentedId: Int {
	case asc = 0
	case desc = 1
}

struct HomeScreen: View {

	@State private var segmentId: SegmentedId = .asc

	@StateObject var textObserver = TextFieldObserver()

	@State var suffixList: [String: Int] = [:]
	@State var topFilteredSuffixes: [(String, String)] = []

	var body: some View {
		VStack {
			textField
			picker
			suffixTableView
		}
	}

	private var textField: some View {
		TextField("Enter Something", text: $textObserver.searchText)
			.textFieldStyle(.roundedBorder)
			.padding()
			.onChange(of: textObserver.debouncedText) { item in
				suffix(text: item.lowercased())
				topSuffixesCalc()
			}
	}

	private var picker: some View {
		Picker("Picker", selection: $segmentId) {
			Text("top 10 tripple suff").tag(SegmentedId.asc)
			Text("asc").tag(SegmentedId.desc)
		}
		.pickerStyle(.segmented)
	}

	private var suffixTableView: some View {
		List {
			switch segmentId {
			case .desc:
				ForEach(suffixList.sorted(by: { $0.value < $1.value }), id: \.key) { (key, value) in
					HStack {
						Text(key)
						Spacer()
						Text("\(value)")
					}
				}
				.scrollContentBackground(.hidden)
			case .asc:
				ForEach(topFilteredSuffixes, id: \.0) { (key, value) in
					HStack {
						Text(key)
						Spacer()
						Text(value)
					}
				}
				.scrollContentBackground(.hidden)
			}
		}
	}


	// MARK: - Private methods

	private func search(text: String) {
		suffix(text: text.lowercased())
	}

	private func suffix(text: String) {
		let words = text.split(separator: " ")
		let suffixArray = words.flatMap{ SuffixSequence(word: String($0)).map { $0 } }
		let suffixes = suffixArray.reduce(into: [:]) { resultSuffixes, suffix in
			resultSuffixes[suffix as! String, default: 0] += 1
		}
		suffixList = suffixes
		topSuffixesCalc()
	}

	private func topSuffixesCalc() {
		let filteredItems = suffixList.filter { $0.value >= 3 && $0.key.count >= 3 }
		let sortedArray = filteredItems.sorted { $0.value > $1.value }
		topFilteredSuffixes = sortedArray.prefix(10).map { (String($0.key), String($0.value)) }
	}
}

struct HomeScreen_Previews: PreviewProvider {
	static var previews: some View {
		HomeScreen()
	}
}
