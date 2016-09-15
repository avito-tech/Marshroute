import Marshroute

protocol ModuleRegisteringService: class {
    func registerTrackedModule(_ trackedModule: TrackedModule)
}
