import UIKit

final class ApplicationViewController: BaseTabBarController, ApplicationViewInput {
    // MARK: - Init
    fileprivate let topViewControllerFindingService: TopViewControllerFindingService
    fileprivate let bannerView: UIView
    
    init(topViewControllerFindingService: TopViewControllerFindingService,
         bannerView: UIView)
    {
        self.topViewControllerFindingService = topViewControllerFindingService
        self.bannerView = bannerView
        
        super.init()
    }
    
    // MARK: - Lifecycle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        onMemoryWarning?()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if case .motionShake = motion {
            onDeviceShake?()
        }
    }
    
    // MARK: - ApplicationViewInput
    func showBanner(_ completion: (() -> ())?) {
        guard bannerView.superview == nil // self is required due to a compiler bug
            else { return }
        
        guard let (topViewController, containerViewController)
            = topViewControllerFindingService.topViewControllerAndItsContainerViewController()
            else { return }
        
        let bannerFrame = CGRect(
            x: 0,
            y: 0,
            width: containerViewController.view.frame.width,
            height: topViewController.defaultContentInsets.top 
        )
        
        bannerView.frame = bannerFrame
    
        containerViewController.view.addSubview(bannerView)
        
        animateBannerIn(bannerView, completion: completion)
    }
    
    func hideBanner() {
        guard bannerView.superview != nil
            else { return }
        
        animateBannerOut(bannerView)
    }
    
    var onMemoryWarning: (() -> ())?
    var onDeviceShake: (() -> ())?
    
    // MARK: - Private
    fileprivate func animateBannerIn(_ bannerView: UIView, completion: (() -> ())?) {
        bannerView.transform = CGAffineTransform(translationX: 0, y: -bannerView.frame.height)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: UIView.AnimationOptions(),
            animations: {
                bannerView.transform = CGAffineTransform.identity
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    fileprivate func animateBannerOut(_ bannerView: UIView) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: UIView.AnimationOptions(),
            animations: {
                bannerView.transform = CGAffineTransform(translationX: 0, y: -bannerView.frame.height)
            }, completion: { _ in
                bannerView.transform = CGAffineTransform.identity
                bannerView.removeFromSuperview()
            }
        )
    }
}
