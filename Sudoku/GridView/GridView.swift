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
                        makeCellViewWithNoteOverlay(position: Position(row: rowIndex, column: cellIndex))
                        
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
        .background(vm.colorPalette.background)
    }
    
    @ViewBuilder
    func makeCellViewWithNoteOverlay(position: Position) -> some View {
        if let cell = $vm.currentPuzzle.wrappedValue?.getCell(at: position) {
            ZStack {
                Rectangle()
                    .fill(vm.getCellColor(position: position))
                    .frame(width: 40, height: 40)
                    .border(Color.black, width: 1)
                    .gridBorderOverlay(for: position, color: vm.colorPalette.gridBorder)
                    
                    
                // Pencil marks grid (only if no value and has notes)
                if cell.value == 0 && !cell.pencilMarks.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<3, id: \.self) { col in
                                    let number = row * 3 + col + 1
                                    Text(cell.pencilMarks.contains(number) ? "\(number)" : "")
                                        .font(.caption2)
                                        .foregroundColor(vm.colorPalette.pencilMarkText)
                                        .frame(width: 13, height: 13, alignment: .center)
                                }
                            }
                        }
                    }
                }

                // Main number (centered)
                if cell.value != 0 {
                    Text("\(cell.value)")
                        .font(.headline)
                        .foregroundStyle(cell.isEditable ? vm.colorPalette.userInputText : vm.colorPalette.givenText)
                }
            }
            .frame(width: 40, height: 40)
            .onTapGesture {
                vm.cellTapped(position: position)
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
                Label(vm.isTakingNotes ? "Disable Notes" : "Enable Notes", systemImage: vm.isTakingNotes ? "pencil.circle.fill" : "pencil.circle" )
                    .foregroundStyle(vm.isTakingNotes ? .blue : .gray)
            }
            
            Button(action: {
                vm.solveButtonTapped()
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
