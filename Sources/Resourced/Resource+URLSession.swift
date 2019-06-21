
import Foundation

extension URLSession {

    /// Fetches a resource using its request and transforms the returned data
    /// using its transform closure.
    ///
    /// - Parameters:
    ///   - resource: The resource to fetch.
    ///   - completion: Completion handler with the result.
    @discardableResult
    public func fetch<Value>(
        _ resource: Resource<Value>,
        completion: @escaping (Result<Value, Error>) -> Void
    ) -> URLSessionDataTask {

        return perform(request: resource.request) { result in

            let value = Result { try resource.transform(result.get()) }
            DispatchQueue.main.async {
                completion(value)
            }
        }
    }

    private func perform(
        request: URLRequest,
        completion: @escaping (Result<(Data, URLResponse), Error>) -> Void
    ) -> URLSessionDataTask {

        let task = dataTask(with: request) { (data, response, error) in

            guard let data = data, let response = response else {
                struct UnknownError: Error {}
                let error = error ?? UnknownError()
                completion(.failure(error))
                return
            }

            completion(.success((data, response)))
        }

        task.resume()
        return task
    }
}
