//
//  ContentView.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import SwiftUI

struct SudokuGridView: View {
    @StateObject var vm: ViewModel
    init(grid: SudokuGrid) {
        _vm = StateObject(wrappedValue: ViewModel(grid: grid))
    }
    
    var body: some View {
        VStack(spacing: 2) {
            
            makeSettingsToolbar()
            
            ForEach(0..<9, id: \.self) { rowIndex in
                HStack(spacing: 2) {
                    ForEach(0..<9, id: \.self) { cellIndex in
                        makeCellView(position: Position(row: rowIndex, column: cellIndex))
                    }
                }
            }
            
            makeInputButtons()
                .padding(.top, 20)
        }
        .task {
            do {
                try await vm.fetchGrid(of: .medium)
            } catch {
                print(error.localizedDescription)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
    }
    
    @ViewBuilder
    func makeCellView(position: Position) -> some View {
        if let cell = $vm.currentPuzzle.wrappedValue?.getCell(at: position) {
            ZStack {
                Rectangle()
                    .fill(vm.getCellColor(position: position))
                    .frame(width: 40, height: 40)
                    .border(Color.black, width: 1)
                
                Text(cell.value == 0 ? "" : "\(cell.value)")
                    .font(.headline)
                    .foregroundStyle(cell.isEditable ? Color.black : Color.blue)
            }
            
            addNoteOverlay(for: cell)
            
            .onTapGesture {
                vm.cellTapped(position: position)
            }
        }
    }
    
    @ViewBuilder
    func addNoteOverlay(for cell: SudokuCell) -> some View {
        if cell.value == 0 && !cell.pencilMarks.isEmpty {
            GeometryReader { geometry in
                let cellSize = geometry.size
                let markSize = cellSize.width / 3

                ZStack {
//                    ForEach(0..<3, id: \.self) { row in
//                        HStack(spacing: 0) {
//                            ForEach(0..<3, id: \.self) { col in
//                                let number = row * 3 + col + 1
//                                Text(cell.pencilMarks.contains(number) ? "\(number)" : "")
//                                    .font(.caption2)
//                                    .foregroundColor(.yellow)
//                                    .frame(width: markSize, height: markSize)
//                            }
//                        }
//                    }
                }
            }
        }
    }

    
    @ViewBuilder
    func makeInputButtons() -> some View {
        HStack(spacing: 4) {
            ForEach(0...9, id: \.self) { number in
                Button(action: {
                    vm.inputTapped(input: number)
                }) {
                    Text("\(number)")
                        .frame(width: 35, height: 35)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                }
            }
        }
    }
    
    @ViewBuilder
    func makeSettingsToolbar() -> some View {
        // Toolbar at the top
        HStack(spacing: 10) {
            // Difficulty Picker
            Picker("Difficulty", selection: $vm.selectedDifficulty) {
                ForEach(GridDifficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue.capitalized).tag(difficulty)
                }
            }
            .pickerStyle(.menu)
            
            // New Puzzle Button
            Button("New Puzzle") {
                Task {
                    do {
                        try await vm.fetchGrid(of: vm.selectedDifficulty)
                    } catch {
                        print("Failed to fetch new puzzle:", error.localizedDescription)
                    }
                }
            }
            
            
            
            // Pencil Button
            Button(action: {
                vm.isTakingNotes.toggle()
            }) {
                Label("Notes", systemImage: vm.isTakingNotes ? "pencil.circle.fill" : "pencil.circle" )
                    .foregroundStyle(vm.isTakingNotes ? .blue : .gray)
            }
            
            Button(action: {
                // solve logic
            }) {
                Label("Solve", systemImage: "checkmark.circle")
            }
            
        }
        .padding()
    }
}

#Preview {
    SudokuGridView(grid: TestData.testGrid)
}
