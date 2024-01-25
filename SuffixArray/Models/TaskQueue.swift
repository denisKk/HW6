//
//  JobSheduler.swift
//  HW_6_OTUS_2023
//
//  Created by Dev on 20.01.24.
//

import Foundation

public actor TaskQueue{
    private let concurrency: Int
    private var running: Int = 0
    private var queue = [CheckedContinuation<Void, Error>]()

    public init(concurrency: Int) {
        self.concurrency = concurrency
    }

    deinit {
        for continuation in queue {
            continuation.resume(throwing: CancellationError())
        }
    }

    public func enqueue<T>(operation: @escaping @Sendable () async throws -> T) async throws -> (result: T, time: Double) {
        try Task.checkCancellation()

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.append(continuation)
            tryRunEnqueued()
        }

        defer {
            running -= 1
            tryRunEnqueued()
        }
        try Task.checkCancellation()

        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
   
        return (result: result, time: duration)
    }

    private func tryRunEnqueued() {
        guard !queue.isEmpty else { return }
        guard running < concurrency else { return }

        running += 1
        let continuation = queue.removeFirst()
        continuation.resume()
    }
}
