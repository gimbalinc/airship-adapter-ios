/* Copyright Airship and Contributors */

import Foundation

/// Task passed to the launcher when ready to execute.
/// - Note: For internal use only. :nodoc:
@objc(UATask)
public protocol AirshipTask {

    /**
     * Completion handler. Will be called once task is completed.
     */
    @objc
    var completionHandler: (() -> Void)? { get set }

    /**
     * The task ID.
     */
    @objc
    var taskID: String { get }

    /**
     * The task request options.
     */
    @objc
    var requestOptions: TaskRequestOptions { get }

    /**
     * The launcher should call this method to signal that the task was completed successfully.
     */
    @objc
    func taskCompleted()

    /**
     * The launcher should call this method to signal the task failed and needs to be retried.
     */
    @objc
    func taskFailed()
}
