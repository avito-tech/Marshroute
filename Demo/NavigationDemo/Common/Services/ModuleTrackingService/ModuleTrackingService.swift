import AvitoNavigation

protocol ModuleTrackingService: class {
    func registerTrackedModule(trackedModule: TrackedModule)
}
