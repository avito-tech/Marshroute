import Marshroute

protocol ModuleRegisteringService: AnyObject {
    func registerTrackedModule(_ trackedModule: TrackedModule)
}
