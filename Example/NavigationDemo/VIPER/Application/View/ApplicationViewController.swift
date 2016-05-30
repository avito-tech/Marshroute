import UIKit

final class ApplicationViewController: BaseTabBarController, ApplicationViewInput {
    // MARK: - Init
    private let topViewControllerFindingService: TopViewControllerFindingService
    private let bannerView: UIView
    
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
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if case .MotionShake = motion {
            onDeviceShake?()
        }
    }
    
    // MARK: - ApplicationViewInput
    func showBanner(completion: (() -> ())?) {
        guard bannerView.superview == nil // self is required due to a compiler bug
            else { return }
        
        guard let (topViewController, containerViewController)
            = topViewControllerFindingService.topViewControllerAndItsContainerViewController()
            else { return }
        
        let bannerFrame = CGRect(
            x: 0,
            y: 0,
            width: containerViewController.view.frame.width,
            height: topViewController.topLayoutGuide.length ?? 44
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
    private func animateBannerIn(bannerView: UIView, completion: (() -> ())?) {
        bannerView.transform = CGAffineTransformMakeTranslation(0, -bannerView.frame.height)
        
        UIView.animateWithDuration(
            0.4,
            delay: 0,
            options: [.CurveEaseInOut],
            animations: {
                bannerView.transform = CGAffineTransformIdentity
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    private func animateBannerOut(bannerView: UIView) {
        UIView.animateWithDuration(
            0.4,
            delay: 0,
            options: [.CurveEaseInOut],
            animations: {
                bannerView.transform = CGAffineTransformMakeTranslation(0, -bannerView.frame.height)
            }, completion:  { _ in
                bannerView.transform = CGAffineTransformIdentity
                bannerView.removeFromSuperview()
            }
        )
    }
}

