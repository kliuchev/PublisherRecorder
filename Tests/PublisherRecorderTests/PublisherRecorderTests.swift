import Testing
import Combine

@testable import PublisherRecorder

@Test func expectedToRecordAllOutputs() {
    let subject = PassthroughSubject<Int, Never>()
    
    let count = 10
    let expectedOutput = (0..<count).map { $0 }
    
    let sut = subject.record()
    
    for output in expectedOutput {
        subject.send(output)
    }
    
    #expect(sut.output == expectedOutput)
}

@Test func expectedToRecordFailure() {
    
    enum CustomError: Error {
        case customErrorExample
    }
    
    let subject = PassthroughSubject<Int, CustomError>()
    
    let sut = subject.record()
    
    subject.send(completion: .failure(.customErrorExample))
    
    #expect(sut.output.isEmpty)
    #expect(sut.completion == .failure(.customErrorExample))
}

@Test func expectedToRecordIsFinished() {
    let subject = PassthroughSubject<Int, Never>()
    
    let sut = subject.record()
    
    subject.send(completion: .finished)
    
    #expect(sut.completion == .finished)
}

@Test func expectedToRecordOutputsAndError() {
    
    enum CustomError: Error {
        case customErrorExample
    }
    
    let subject = PassthroughSubject<Int, CustomError>()
    
    let count = 10
    let expectedOutput = (0..<count).map { $0 }
    
    let sut = subject.record()
    
    for output in expectedOutput {
        subject.send(output)
    }
    
    subject.send(completion: .failure(.customErrorExample))
    
    #expect(sut.output == expectedOutput)
    #expect(sut.completion == .failure(.customErrorExample))
}

@Test func viewModel() async {
    
    /// A simple view model that simulates loading work when the view appears.
    /// - Exposes `isLoading` as a published property so UI (or tests) can observe changes.
    /// - Calling `onAppear()` will:
    ///   1. Set `isLoading = true`
    ///   2. Perform simulated async work
    ///   3. Reset `isLoading = false` when finished
    final class MyViewModel: ObservableObject {
        @Published private(set) var isLoading: Bool = false
                
        func onAppear() async {
            isLoading = true
            defer { isLoading = false }
            
            // simulate loading work, e.g. network call
            try? await Task.sleep(for: .milliseconds(10))
        }
    }

    let vm = MyViewModel()

    // Record changes of `isLoading`
    let sut = vm.$isLoading.record()

    await vm.onAppear()

    // assert full state transition: false → true → false
    #expect(sut.output == [false, true, false])
}
