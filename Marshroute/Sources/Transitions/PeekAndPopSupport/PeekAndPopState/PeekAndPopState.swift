public enum PeekAndPopState {
    case inPeek
    case interrupted
    case popped
 
    // Note: there is no `case cancelled` here, because there is no reliable way to identify this state.
    //
    // Before iOS 11 it was possible to observe `state` of a `previewingGestureRecognizerForFailureRelationship`
    // on an active previewing context. On iOS 11 Apple addressed this case more closely and closed the opportunity.
    //
    // Anyway, `case cancelled` may be somehow replaced with view controller's deinitialization event.
}
