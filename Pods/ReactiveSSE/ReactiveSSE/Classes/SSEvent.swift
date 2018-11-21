public struct SSEvent {
    public var type: String
    public var data: String // Event streams in this format must always be encoded as UTF-8

    // public memberwise init with default values
    public init(type: String = "message", data: String = "") {
        self.type = type
        self.data = data
    }

    init(_ eses: [EventStream.Event]) {
        self = eses.flatMap { e -> EventStream.Field? in
            switch e {
            case .comment: return nil // ignored
            case .field(let f): return f
            }}
            .reduce(into: SSEvent()) { sse, f in
                switch f.name {
                case "event": sse.type = f.value
                case "data": sse.data = f.value
                case "id": break // TODO
                case "retry": break // TODO
                default: break // ignored
                }
        }
    }
}
