//
//  QReaderViewController.m
//  QReader, https://github.com/rsimenok/QReader
//
//  Created by Roman Simenok on 11/28/17. All rights reserved.
//

#import "QReaderViewController.h"

@interface QReaderViewController ()

@property (strong, nonatomic) QReader *codeReader;

@end

@implementation QReaderViewController

- (instancetype)init {
    return [self initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
}

- (instancetype)initWithMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes {
    if (self = [super init]) {
        [self setupRecorderWithMetadataObjectTypes:metadataObjectTypes];
    }
    
    return self;
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes {
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupRecorderWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
    
    return self;
}

- (void)setupRecorderWithMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes {
    self.codeReader = [QReader readerWithMetadataObjectTypes:metadataObjectTypes];
    self.codeReader.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)dealloc {
    [self.codeReader stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer insertSublayer:self.codeReader.previewLayer atIndex:0];
#warning TODO using constrains!
    self.codeReader.previewLayer.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.codeReader startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.codeReader stopScanning];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.codeReader.previewLayer.frame = self.view.bounds;
}

#pragma mark - Controlling the Reader

- (void)startScanning {
    [_codeReader startScanning];
}

- (void)stopScanning {
    [_codeReader stopScanning];
}

#pragma mark - Managing the Orientation

- (void)orientationChanged:(NSNotification *)notification {
#warning edit
    [self.view setNeedsDisplay];
    
    if (self.codeReader.previewLayer.connection.isVideoOrientationSupported) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        self.codeReader.previewLayer.connection.videoOrientation = [QReader videoOrientationFromInterfaceOrientation:
                                                                orientation];
    }
}

#pragma mark - QReaderDelegate

- (void)readerDidScanWithResult:(NSString *)result {
    [self stopScanning];
    
    if ([self.delegate respondsToSelector:@selector(readerDidScanWithResult:)]) {
        [self.delegate readerDidScanWithResult:result];
    }
}

@end
