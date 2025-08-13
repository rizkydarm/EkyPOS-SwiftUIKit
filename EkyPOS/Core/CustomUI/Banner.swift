import UIKit
import NotificationBannerSwift

func showBanner(_ type: BannerStyle, title: String, message: String, seconds: Double = 1, vc: UIViewController? = nil, bannerPosition: BannerPosition = .bottom) {
    let banner = NotificationBanner(title: title, subtitle: message, style: type)
    banner.duration = seconds
    banner.bannerHeight = 100
    banner.show(queuePosition: .front, bannerPosition: bannerPosition, on: vc)
}