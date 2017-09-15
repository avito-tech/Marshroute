import Foundation

protocol ModuleTrackingService: class {
    func doesTrackedModuleExistInHistory(_ trackedModule: TrackedModule) -> Bool?
}
