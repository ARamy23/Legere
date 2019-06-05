import Vapor

/// Logs all requests passing through it
final class LogMiddleware: Middleware {
    // Create a stored property to hold a Logger.
    let logger: Logger
    init(logger: Logger) {
        self.logger = logger
    }
    // Implement the Middleware protocol requirement.
    func respond(
        to req: Request,
        chainingTo next: Responder) throws -> Future<Response> {
        // First, create a start time. Do this before any additional work is done to get the most accurate response time measurement.
        let start = Date()
        return try next.respond(to: req).map { res in
            // Instead of returning the response directly, map the future result so that you can access the Response object. Pass this to log(_:start:for:).
            self.log(res, start: start, for: req)
            return res }
    }
    // This method logs the response for an incoming request using the response start date.
    func log(_ res: Response, start: Date, for req: Request) {
        let reqInfo = "\(req.http.method.string) \(req.http.url.path)"
        let resInfo = "\(res.http.status.code) " +
        "\(res.http.status.reasonPhrase)"
        
        // Generate a readable time using timeIntervalSince(_:) and the extension on TimeInterval at the bottom of the file.
        let time = Date()
            .timeIntervalSince(start)
            .readableMilliseconds
        // Log the information string.
        logger.info("\(reqInfo) -> \(resInfo) [\(time)]")
    }
}
// Allow LogMiddleware to be registered as a service in your application.
extension LogMiddleware: ServiceType {
    static func makeService(
        for container: Container) throws -> LogMiddleware {
        // Initialize an instance of LogMiddleware, using the container to create the necessary Logger.
        return try .init(logger: container.make())
    }
}

extension TimeInterval {
    /// Converts the time internal to readable milliseconds format, i.e., "3.4ms"
    var readableMilliseconds: String {
        let string = (self * 1000).description
        // include one decimal point after the zero
        let endIndex = string.index(string.index(of: ".")!, offsetBy: 2)
        let trimmed = string[string.startIndex..<endIndex]
        return .init(trimmed) + "ms"
    }
}
