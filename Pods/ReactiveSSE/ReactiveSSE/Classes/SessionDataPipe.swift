import ReactiveSwift

final class SessionDataPipe: NSObject, URLSessionDataDelegate {
    let pipe = Signal<String, SSError>.pipe()

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse else { return completionHandler(.cancel) }
        guard response.statusCode == 200,
            response.mimeType == "text/event-stream" else {
                pipe.input.send(error: .notSSE(statusCode: response.statusCode, mimeType: response.mimeType))
                return completionHandler(.cancel)
        }
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let s = String(data: data, encoding: .utf8) else {
            pipe.input.send(error: .nonUTF8(data))
            return
        }
        pipe.input.send(value: s)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        pipe.input.send(error: .session(error as NSError?))
    }
}
