import UIKit
import Marshroute

protocol AdvertisementAssembly: class {
    func module(searchResultId searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(searchResultId searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
}
