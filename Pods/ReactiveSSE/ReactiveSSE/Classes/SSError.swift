import Foundation

public enum SSError: Error {
    case notSSE(statusCode: Int, mimeType: String?)
    case nonUTF8(Data)
    case session(NSError?)
}
