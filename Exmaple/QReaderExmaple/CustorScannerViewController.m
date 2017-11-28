//
//  CustorScannerViewController.m
//  QReaderExmaple
//
//  Created by Roman Simenok on 11/28/17.
//  Copyright © 2017 Roman Simenok. All rights reserved.
//

#import "CustorScannerViewController.h"

@interface CustorScannerViewController ()

@end

@implementation CustorScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


// ovverride QReaderDelegate method to handle results
- (void)readerDidScanWithResult:(NSString *)result {
    [super readerDidScanWithResult:result];
    
    NSLog(@"result: %@", result);
}

@end
