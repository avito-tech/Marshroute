import Marshroute

protocol ModuleRegisteringService: class {
    func registerTrackedModule(trackedModule: TrackedModule)
}
