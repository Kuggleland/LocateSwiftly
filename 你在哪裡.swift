import CoreLocation

protocol WhereDelegate {
    func locationReceived(received: CLLocation);
    func locationError(error: NSError!);
    func StringMessages(message: String);
    func authDidChange(status: CLAuthorizationStatus);
}


class 你在哪裡 : NSObject , CLLocationManagerDelegate {
    static let sharedInstance = 你在哪裡()
    var 📌💼: CLLocationManager!
    var 📌📝: String!
    var delegate:WhereDelegate! = nil
    
    override init() {
        super.init()
        📌📝 = "initialized"
        initLocationServices()
    }
    
    func initLocationServices() {
        📌💼 = CLLocationManager()
        📌💼.requestAlwaysAuthorization()
        📌💼.delegate = self
    }
    
    func setAccuracy(accuracyType : Int) {
        if (accuracyType == 1) {
            📌💼.desiredAccuracy = kCLLocationAccuracyKilometer
        } else {
            📌💼.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }

    func startForegroundLocation() {
        setAccuracy(0)
        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "location.foreground")
        📌💼.requestAlwaysAuthorization()
        📌💼.startUpdatingLocation()
        📌📝 = "foreground.start"
        delegate.StringMessages(📌📝)
    }
    func stopForegroundLocation() {
        if (NSUserDefaults.standardUserDefaults().stringForKey("location.foreground") == "yes") {
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "location.foreground")
            setAccuracy(1)
            📌💼.stopUpdatingLocation()
            📌📝 = "foreground.stop"
            delegate.StringMessages(📌📝)
            
        }
    }
    
    func startBackgroundLocation() {
        setAccuracy(1)
        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "location.background")
        📌💼.startMonitoringSignificantLocationChanges()
        📌📝 = "background.start"
        delegate.StringMessages(📌📝)
    }
    func stopBackgroundLocation() {
        if (NSUserDefaults.standardUserDefaults().stringForKey("location.background") == "yes") {
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "location.background")
            setAccuracy(0)
            📌💼.stopMonitoringSignificantLocationChanges()
            📌📝 = "background.stop"
            delegate.StringMessages(📌📝)
        }
    }
    
    // Delegates
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        📌📝 = "error.general"
        delegate.StringMessages(📌📝)
        delegate.locationError(error)
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
            delegate.locationReceived(newLocation)
            
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%2.6f", newLocation.coordinate.latitude), forKey: "loc.lat")
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%2.6f", newLocation.coordinate.longitude), forKey: "loc.lng")
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%2.6f", newLocation.horizontalAccuracy), forKey: "loc.acc")
            delegate.StringMessages(📌📝)
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            delegate.authDidChange(status)
            if (status == CLAuthorizationStatus.Restricted || status == CLAuthorizationStatus.Denied) {
                📌📝 = "error.deny"
                delegate.StringMessages(📌📝)
            }
    }
}
