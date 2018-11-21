import ReactiveSwift

private let defaultMaxBuffer = 10_000_000

extension Signal where Value == String {
    public func serverSentEvents(maxBuffer: Int? = nil) -> Signal<SSEvent, Error> {
        let maxBuffer = maxBuffer ?? defaultMaxBuffer
        var buffer: String = ""
        return .init { observer, lifetime in
            lifetime += self.observe { event in
                switch event {
                case .value(let s):
                    guard buffer.count + s.count <= maxBuffer else {
                        NSLog("%@", "\(#function): buffer size is about to be maxBuffer. automatically resetting buffers.")
                        buffer.removeAll()
                        return
                    }
                    buffer += s

                    // try parsing or wait for next data (incomplete buffer)
                    guard let parsed = try? EventStream.event.parse(AnyCollection(buffer)) else { return }

                    observer.send(value: SSEvent(parsed.output))

                    buffer = String(parsed.remainder)
                case .failed(let e):
                    observer.send(error: e)
                case .completed:
                    observer.send(.completed)
                case .interrupted:
                    observer.send(.interrupted)
                }
            }
        }
    }
}
