import Combine

public final class PublisherRecorder<Output, Failure : Error> {
    
    public internal(set) var output: [Output] = []
    
    public internal(set) var completion: Subscribers.Completion<Failure>?
    
    public internal(set) var cancelable: AnyCancellable?
}

public extension Publisher {
    func record() -> PublisherRecorder<Output, Failure> {
        let recorder = PublisherRecorder<Output, Failure>()
        let cancelable = sink { [weak recorder] completion in
            recorder?.completion = completion
        } receiveValue: { [weak recorder] output in recorder?.output.append(output) }
        
        recorder.cancelable = cancelable
        
        return recorder
    }
}
