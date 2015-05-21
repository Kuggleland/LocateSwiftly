import CoreLocation
import Foundation

class 你在哪裡 : NSObject , CLLocationManagerDelegate {
    static let sharedInstance = 你在哪裡()
    var 📌💼: CLLocationManager!
    var 📌📝: String!
    var 📌: CLLocation!
    
    override init() {
        super.init()
        📌📝 = "initialized"
        initLocationServices()
    }
    
    func initLocationServices() {
        📌💼 = CLLocationManager()
        📌💼.requestAlwaysAuthorization()
        📌💼.delegate = self
        postNotification(📌📝)
    }
    
    func setAccuracy(accuracyType : Int) {
        if (accuracyType == 1) {
            📌💼.desiredAccuracy = kCLLocationAccuracyKilometer
        } else {
            📌💼.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    func postNotification(message : String) {
        NSNotificationCenter.defaultCenter().postNotificationName(message, object: nil)
    }
    
    func startForegroundLocation() {
        setAccuracy(0)
        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "location.foreground")
        📌💼.requestAlwaysAuthorization()
        📌💼.startUpdatingLocation()
        📌📝 = "foreground.start"
        postNotification(📌📝)
    }
    
    func stopForegroundLocation() {
        if (NSUserDefaults.standardUserDefaults().stringForKey("location.foreground") == "yes") {
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "location.foreground")
            setAccuracy(1)
            📌💼.stopUpdatingLocation()
            📌📝 = "foreground.stop"
            postNotification(📌📝)
            
        }
    }
    
    func startBackgroundLocation() {
        setAccuracy(1)
        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "location.background")
        📌💼.startMonitoringSignificantLocationChanges()
        📌📝 = "background.start"
        postNotification(📌📝)
    }
    func stopBackgroundLocation() {
        if (NSUserDefaults.standardUserDefaults().stringForKey("location.background") == "yes") {
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "location.background")
            setAccuracy(0)
            📌💼.stopMonitoringSignificantLocationChanges()
            📌📝 = "background.stop"
            postNotification(📌📝)
        }
    }
    
    // Delegates
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        📌📝 = "error.general"
        postNotification(📌📝)
    }

    func locationManager(manager: CLLocationManager!,
        didUpdateToLocation newLocation: CLLocation!,
        fromLocation oldLocation: CLLocation!) {
            if (newLocation.timestamp.timeIntervalSinceNow < -1.0) { return }
            if (newLocation.horizontalAccuracy < 0) { return }
            if (NSUserDefaults.standardUserDefaults().stringForKey("location.foreground") == "yes") {
                stopForegroundLocation()
            }
            📌📝 = "location.updated"
            // Keep on logging if its a background location
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%2.6f", newLocation.coordinate.latitude), forKey: "loc.lat")
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%2.6f", newLocation.coordinate.longitude), forKey: "loc.lng")
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%2.6f", newLocation.horizontalAccuracy), forKey: "loc.acc")
            📌 = newLocation
            postNotification(📌📝)
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            if (status == CLAuthorizationStatus.Restricted || status == CLAuthorizationStatus.Denied) {
                📌📝 = "error.deny"
                postNotification(📌📝)
            }
    }
}
