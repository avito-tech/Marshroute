import Foundation

protocol ModuleTrackingService: class {
    func doesTrackedModuleExistInHistory(trackedModule: TrackedModule) -> Bool?
}
