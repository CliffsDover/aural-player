/*
    A collection of constants for use by the UI
*/
import Cocoa

struct UIConstants {
    
    // Playlist view column identifiers
    static let playlistIndexColumnID: String = "cid_Index"
    static let playlistNameColumnID: String = "cid_Name"
    static let playlistDurationColumnID: String = "cid_Duration"
    
    // Track info view column identifiers (popover)
    static let trackInfoKeyColumnID: String = "cid_TrackInfoKey"
    static let trackInfoValueColumnID: String = "cid_TrackInfoValue"
    
    // Index set used to reload specific playlist rows
    static let flatPlaylistViewColumnIndexes: IndexSet = IndexSet([0, 1, 2])
    static let groupingPlaylistViewColumnIndexes: IndexSet = IndexSet([0, 1])
    
    // Angles used to fill gradients
    static let verticalGradientDegrees: CGFloat = -90.0
    static let horizontalGradientDegrees: CGFloat = -180.0
    
    // Default seek timer interval (milliseconds)
    static let seekTimerIntervalMillis: Int = 500
    
    // Recorder timer interval (milliseconds)
    static let recorderTimerIntervalMillis: Int = 500
    
    // Time intervals for which feedback labels or views that are to be auto-hidden are displayed, before being hidden
    static let feedbackLabelAutoHideIntervalSeconds: TimeInterval = 1
    static let favoritesPopupAutoHideIntervalSeconds: TimeInterval = 1.5
    
    // Maximum time gap between scroll events for them to be considered as being part of the same scroll session
    static let scrollSessionMaxTimeGapSeconds: TimeInterval = (1/6)
}
