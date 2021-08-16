import Foundation

protocol ModuleTrackingService: AnyObject {
    func doesTrackedModuleExistInHistory(_ trackedModule: TrackedModule) -> Bool?
}
