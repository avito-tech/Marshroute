import UIKit
import Marshroute

protocol AdvertisementAssembly: class {
    func module(searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
}
