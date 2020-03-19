//
//  MapViewController.swift
//  SwiftDemo
//
//  Created by 刘科尧 on 2020/3/18.
//  Copyright © 2020 刘科尧. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mapView:MKMapView!
    var locationManager:CLLocationManager!
    var geocoder:CLGeocoder!    // 字符串地址与经纬度互转管理器
    
    var arrayCoord:Array<CLLocationCoordinate2D>! = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // 传入轨迹数据
    init(arrayCoord:Array<CLLocationCoordinate2D>) {
        super.init(nibName: nil, bundle: nil)
        self.arrayCoord = arrayCoord
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Map"
        setupUI()
    }
    
    func setupUI() {
        self.mapView = MKMapView.init(frame: CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.mapView.delegate = self
        self.mapView.userTrackingMode = MKUserTrackingMode.follow
        self.view.addSubview(self.mapView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "findMe", style: UIBarButtonItem.Style.done, target: self, action: #selector(findMe))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "drawTrail", style: UIBarButtonItem.Style.done, target: self, action: #selector(drawTrail))
        
        // 获取定位授权
        getLocationPower()
    }
    
    func getLocationPower() {
        
        // 显示用户当前位置
        self.mapView.showsUserLocation = true
        self.locationManager = CLLocationManager.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 间隔多少米重新定位
//        self.locationManager.distanceFilter = 100
        // 获取用户授权使用定位功能
        //        let status = CLLocationManager.authorizationStatus()
        //        if status == CLAuthorizationStatus.notDetermined {
        //            self.locationManager.requestAlwaysAuthorization()
        //        }
        //        if !CLLocationManager.locationServicesEnabled() {
        //            print("open location")
        //        } else {
        //
        //        }
        if self.locationManager.responds(to: NSSelectorFromString("requestWhenInUseAuthorization")) {
            self.locationManager.requestAlwaysAuthorization()
//            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // 定位
    @objc func findMe() {
        self.locationManager.startUpdatingLocation()
    }
    // 绘出运动轨迹
    @objc func drawTrail() {
        var arrayCoord:Array<CLLocationCoordinate2D> = []
        if self.arrayCoord.count == 0 {
            // 当传入数据为空时，模拟数据绘出轨迹
            for i in 0...30 {
                let coord:CLLocationCoordinate2D! = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(22 + i), longitude: CLLocationDegrees(114 + i))
                arrayCoord.append(coord)
            }
        }
        let polyLine:MKPolyline = MKPolyline.init(coordinates: arrayCoord, count: arrayCoord.count)
        self.mapView.addOverlay(polyLine)
    }
    
    // MARK: -MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // 根据添加的polyline数组，绘出对应的路线图
//        let renderer:MKPolylineRenderer! = MKPolylineRenderer.init(overlay: overlay)
//        renderer.strokeColor = UIColor.blue
        
        // 设置多种颜色的路线图
        if let overlay = overlay as? MKPolyline {
            /// define a list of colors you want in your gradient
            let gradientColors = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.red]
            
            /// Initialise a GradientPathRenderer with the colors
            let polylineRenderer = GradientPathRenderer(polyline: overlay, colors: gradientColors)
            
            /// set a linewidth
            polylineRenderer.lineWidth = 7
            return polylineRenderer
        }
        return MKPolylineRenderer.init()
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // 地图的显示区域即将发生改变的时候调用
        print("\(#function)")
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 地图的显示区域已经发生改变的时候调用
        print("\(#function)")
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        // 地图正在移动
//        print("\(#function)")
    }

    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        // 正在加载地图
        print("\(#function)")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // 地图加载完成
        print("\(#function)")
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("\(#function)")
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("\(#function)")
    }

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("\(#function)")
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 改变授权状态
        print("\(#function)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // 手机朝向
        print("\(#function)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 定位失败
        print("\(#function)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 定位成功
        print("\(#function)")
        // 移动地图视角到定位目标处
//        let lastLocation:CLLocation! = locations.last
//        self.mapView.setRegion(MKCoordinateRegion.init(center: lastLocation.coordinate, latitudinalMeters: lastLocation.coordinate.latitude, longitudinalMeters: lastLocation.coordinate.longitude), animated: true)

        self.locationManager.stopUpdatingLocation()
    }

}
