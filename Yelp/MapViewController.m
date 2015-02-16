//
//  MapViewController.m
//  Yelp
//
//  Created by Vijay Ramakrishnan on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.774866 longitude:-122.394556];
    CLGeocoder *currLocation = [[CLGeocoder alloc] init];
    [currLocation reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *res = [placemarks objectAtIndex:0];
            MKCoordinateRegion region;
            CLLocationCoordinate2D loc = [res.location coordinate];
            region.center = [(CLCircularRegion *) res.region center];
            
            //drop pin
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:loc];
            [annotation setTitle:@"You are here"];
            [self.mapView addAnnotation:annotation];
            
            //scroll to region
            MKMapRect mr = [self.mapView visibleMapRect];
            MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
            mr.origin.x = pt.x - mr.size.width * 0.5;
            mr.origin.y = pt.y - mr.size.height * 0.25;
            [self.mapView setVisibleMapRect:mr animated:YES];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
