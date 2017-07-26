/*
Encapsulates all AuralPlayer settings/state. Is persisted to disk upon exit and loaded into the application upon startup.
*/

import Cocoa

class SavedPlayerState {
    
    // Set defaults so that, if the config file cannot be found/loaded, UI can
    // use defaults
    
    var showPlaylist: Bool = PlayerDefaults.showPlaylist
    var showEffects: Bool = PlayerDefaults.showPlaylist
    
    var repeatMode: RepeatMode = PlayerDefaults.repeatMode
    var shuffleMode: ShuffleMode = PlayerDefaults.shuffleMode
    
    var volume: Float = PlayerDefaults.volume
    var muted: Bool = PlayerDefaults.muted
    var balance: Float = PlayerDefaults.balance
    
    var eqGlobalGain: Float = PlayerDefaults.eqGlobalGain
    var eqBands: [Int: Float] = [Int: Float]() // Freq -> Gain
    
    var pitchBypass: Bool = PlayerDefaults.pitchBypass
    var pitch: Float = PlayerDefaults.pitch
    var pitchOverlap: Float = PlayerDefaults.pitchOverlap
    
    var timeBypass: Bool = PlayerDefaults.timeBypass
    var timeStretchRate: Float = PlayerDefaults.timeStretchRate
    
    var reverbBypass: Bool = PlayerDefaults.reverbBypass
    var reverbPreset: ReverbPresets = PlayerDefaults.reverbPreset
    var reverbAmount: Float = PlayerDefaults.reverbAmount
    
    var delayBypass: Bool = PlayerDefaults.delayBypass
    var delayAmount: Float = PlayerDefaults.delayAmount
    var delayTime: Double = PlayerDefaults.delayTime
    var delayFeedback: Float = PlayerDefaults.delayFeedback
    var delayLowPassCutoff: Float = PlayerDefaults.delayLowPassCutoff
    
    var filterBypass: Bool = PlayerDefaults.filterBypass
    var filterBassMin: Float = PlayerDefaults.filterBassMin
    var filterBassMax: Float = PlayerDefaults.filterBassMax
    var filterMidMin: Float = PlayerDefaults.filterMidMin
    var filterMidMax: Float = PlayerDefaults.filterMidMax
    var filterTrebleMin: Float = PlayerDefaults.filterTrebleMin
    var filterTrebleMax: Float = PlayerDefaults.filterTrebleMax
    
    // List of track file paths
    var playlist: [String] = [String]()
    
    static let defaults: SavedPlayerState = SavedPlayerState()
    
    init() {
        
        // Freqs are powers of 2, starting with 2^5=32 ... 2^14=16k
        for i in 5...14 {
            eqBands[Int(pow(2.0, Double(i)))] = PlayerDefaults.eqBandGain
        }
    }
    
    // Produces an equivalent object suitable for serialization as JSON
    func forWritingAsJSON() -> NSDictionary {
        
        var dict = [NSString: AnyObject]()
        
        dict["showPlaylist"] = showPlaylist as AnyObject
        dict["showEffects"] = showEffects as AnyObject
        
        dict["repeatMode"] = repeatMode.toString as AnyObject
        dict["shuffleMode"] = shuffleMode.toString as AnyObject
        
        dict["volume"] = volume as NSNumber
        dict["muted"] = muted as AnyObject
        dict["balance"] = balance as NSNumber
        
        dict["eqGlobalGain"] = eqGlobalGain as NSNumber
        
        var eqBandsDict = [NSString: NSNumber]()
        for (freq,gain) in eqBands {
            eqBandsDict[String(freq) as NSString] = gain as NSNumber
        }
        dict["eqBands"] = eqBandsDict as AnyObject
        
        var pitchDict = [NSString: AnyObject]()
        pitchDict["bypass"] = pitchBypass as AnyObject
        pitchDict["pitch"] = pitch as NSNumber
        pitchDict["overlap"] = pitchOverlap as NSNumber
        dict["pitch"] = pitchDict as AnyObject
        
        var timeDict = [NSString: AnyObject]()
        timeDict["bypass"] = timeBypass as AnyObject
        timeDict["rate"] = timeStretchRate as NSNumber
        dict["time"] = timeDict as AnyObject
        
        var reverbDict = [NSString: AnyObject]()
        reverbDict["bypass"] = reverbBypass as AnyObject
        reverbDict["preset"] = reverbPreset.toString as AnyObject
        reverbDict["amount"] = reverbAmount as NSNumber
        dict["reverb"] = reverbDict as AnyObject
        
        var delayDict = [NSString: AnyObject]()
        delayDict["bypass"] = delayBypass as AnyObject
        delayDict["amount"] = delayAmount as NSNumber
        delayDict["time"] = delayTime as NSNumber
        delayDict["feedback"] = delayFeedback as NSNumber
        delayDict["lowPassCutoff"] = delayLowPassCutoff as NSNumber
        dict["delay"] = delayDict as AnyObject
        
        var filterDict = [NSString: AnyObject]()
        filterDict["bypass"] = filterBypass as AnyObject
        filterDict["bassMin"] = filterBassMin as NSNumber
        filterDict["bassMax"] = filterBassMax as NSNumber
        filterDict["midMin"] = filterMidMin as NSNumber
        filterDict["midMax"] = filterMidMax as NSNumber
        filterDict["trebleMin"] = filterTrebleMin as NSNumber
        filterDict["trebleMax"] = filterTrebleMax as NSNumber
        dict["filter"] = filterDict as AnyObject
        
        dict["playlist"] = NSArray(array: playlist)
        
        return dict as NSDictionary
    }
    
    // Produces a SavedPlayerState object from deserialized JSON
    static func fromJSON(_ jsonObject: NSDictionary) -> SavedPlayerState  {
        
        // TODO: Make this more resilient to missing/invalid fields
        
        let state = SavedPlayerState()
        
        if let showPlaylist = jsonObject["showPlaylist"] as? Bool {
            state.showPlaylist = showPlaylist
        }
        
        if let showEffects = jsonObject["showEffects"] as? Bool {
            state.showEffects = showEffects
        }
        
        if let repeatMode = jsonObject["repeatMode"] as? String {
            state.repeatMode = RepeatMode.fromString(repeatMode)
        }
        
        if let shuffleMode = jsonObject["shuffleMode"] as? String {
            state.shuffleMode = ShuffleMode.fromString(shuffleMode)
        }
        
        state.volume = (jsonObject["volume"] as! NSNumber).floatValue
        state.muted = (jsonObject["muted"] as! Bool)
        state.balance = (jsonObject["balance"] as! NSNumber).floatValue
        
        state.eqGlobalGain = (jsonObject["eqGlobalGain"] as! NSNumber).floatValue
        
        let eqBands: NSDictionary = jsonObject["eqBands"] as! NSDictionary
        for (freq,gain) in eqBands {
            let freqInt = Int(freq as! String)
            state.eqBands[freqInt!] = (gain as! NSNumber).floatValue
        }
        
        if let pitchDict = (jsonObject["pitch"] as? NSDictionary) {
            state.pitchBypass = (pitchDict["bypass"] as! Bool)
            state.pitch = (pitchDict["pitch"] as! NSNumber).floatValue
            state.pitchOverlap = (pitchDict["overlap"] as! NSNumber).floatValue
        }
        
        if let timeDict = (jsonObject["time"] as? NSDictionary) {
            state.timeBypass = (timeDict["bypass"] as! Bool)
            state.timeStretchRate = (timeDict["rate"] as! NSNumber).floatValue
        }
        
        if let reverbDict = (jsonObject["reverb"] as? NSDictionary) {
            state.reverbBypass = (reverbDict["bypass"] as! Bool)
            state.reverbPreset = ReverbPresets.fromString(reverbDict["preset"] as! String)
            state.reverbAmount = (reverbDict["amount"] as! NSNumber).floatValue
        }
        
        if let delayDict = (jsonObject["delay"] as? NSDictionary) {
            state.delayBypass = (delayDict["bypass"] as! Bool)
            state.delayAmount = (delayDict["amount"] as! NSNumber).floatValue
            state.delayTime = (delayDict["time"] as! NSNumber).doubleValue
            state.delayFeedback = (delayDict["feedback"] as! NSNumber).floatValue
            state.delayLowPassCutoff = (delayDict["lowPassCutoff"] as! NSNumber).floatValue
        }
        
        if let filterDict = (jsonObject["filter"] as? NSDictionary) {
            state.filterBypass = (filterDict["bypass"] as! Bool)
            
            if let bassMin = (filterDict["bassMin"] as? NSNumber) {
                state.filterBassMin = bassMin.floatValue
            }
            
            if let bassMax = (filterDict["bassMax"] as? NSNumber) {
                state.filterBassMax = bassMax.floatValue
            }
            
            if let midMin = (filterDict["midMin"] as? NSNumber) {
                state.filterMidMin = midMin.floatValue
            }
            
            if let midMax = (filterDict["midMax"] as? NSNumber) {
                state.filterMidMax = midMax.floatValue
            }
            
            if let trebleMin = (filterDict["trebleMin"] as? NSNumber) {
                state.filterTrebleMin = trebleMin.floatValue
            }
            
            if let trebleMax = (filterDict["trebleMax"] as? NSNumber) {
                state.filterTrebleMax = trebleMax.floatValue
            }
        }
        
        if let playlist = jsonObject["playlist"] as? [String] {
            state.playlist = playlist
        }
        
        return state
    }
}
