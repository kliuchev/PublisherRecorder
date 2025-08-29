# PublisherRecorder

A minimal utility for recording `Combine.Publisher` outputs and completions in tests.  
Great for testing `@Published` properties and custom publishers without boilerplate.

---

## Why use PublisherRecorder?

Testing Combine publishers often requires capturing:

- **All values** emitted by the publisher  
- **Completion state** (`finished` or `failure`)  

Normally, you would need to manually collect publisher outputs and track completion with boilerplate code.  
`PublisherRecorder` simplifies this into a single, minimal object ready for testing.

---

## Features

- ✅ Records all emitted values (`[Output]`)  
- ✅ Tracks completion (`Subscribers.Completion<Failure>`)  
- ✅ Works with any Combine `Publisher`  
- ✅ Minimal dependency: only Combine + Swift standard library  
- ✅ Designed specifically for unit tests

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kliuchev/PublisherRecorder.git", from: "1.0.0")
]
```

---

## Usage

### Recording a Publisher

```swift
import Combine
import PublisherRecorder

let subject = PassthroughSubject<Int, Never>()
let recorder = subject.record()

subject.send(1)
subject.send(2)
subject.send(completion: .finished)

print(recorder.output)     // [1, 2]
print(recorder.completion) // .finished
```

### Testing a ViewModel

You can also test @Published properties on your view models.
Here’s a simple example simulating loading state transitions:

```swift
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
```

