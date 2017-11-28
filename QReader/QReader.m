//
//  QReader.m
//  QReader, https://github.com/rsimenok/QReader
//
//  Created by Roman Simenok on 11/28/17. All rights reserved.
//

#import "QReader.h"

@interface QReader () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput *metadataOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (copy, nonatomic) void (^completionBlock) (NSString *);

@end

@implementation QReader

#pragma mark - Initializing

- (instancetype)init {
    return [self initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
}

- (instancetype)initWithMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes {
    if (self = [super init]) {
        _metadataObjectTypes = metadataObjectTypes;
        
        [self setupAVComponents];
        [self configueComponents];
    }
    
    return self;
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes {
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

- (void)setupAVComponents {
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        self.session = [[AVCaptureSession alloc] init];
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
}

- (void)configueComponents {
    [_session addOutput:_metadataOutput];
    
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    NSMutableSet *available = [NSMutableSet setWithArray:[_metadataOutput availableMetadataObjectTypes]];
    NSSet *desired = [NSSet setWithArray:_metadataObjectTypes];
    [available intersectSet:desired];
    [_metadataOutput setMetadataObjectTypes:available.allObjects];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)startScanning {
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)stopScanning {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (BOOL)isRunning {
    return self.session.isRunning;
}

- (void)toggleTorch {
    NSError *error = nil;

    [_defaultDevice lockForConfiguration:&error];
    
    if (!error) {
        AVCaptureTorchMode mode = _defaultDevice.torchMode;
        
        _defaultDevice.torchMode = mode == AVCaptureTorchModeOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
    }
    
    [_defaultDevice unlockForConfiguration];
}

- (BOOL)isTorchEnabled {
    return _defaultDevice.isTorchActive;
}

#pragma mark - Checking the Reader Availabilities

+ (BOOL)isAvailable {
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        return YES;
    }
}

+ (BOOL)supportsMetadataObjectTypes:(NSArray *)metadataObjectTypes {
    if (![self isAvailable]) {
        return NO;
    }
    
    @autoreleasepool {
        // Setup components
        AVCaptureDevice *captureDevice    = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        AVCaptureMetadataOutput *output   = [[AVCaptureMetadataOutput alloc] init];
        AVCaptureSession *session         = [[AVCaptureSession alloc] init];
        
        [session addInput:deviceInput];
        [session addOutput:output];
        
        if (metadataObjectTypes == nil || metadataObjectTypes.count == 0) {
            // Check the QRCode metadata object type by default
            metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        }
        
        for (NSString *metadataObjectType in metadataObjectTypes) {
            if (![output.availableMetadataObjectTypes containsObject:metadataObjectType]) {
                return NO;
            }
        }
        
        return YES;
    }
}

#pragma mark - Managing the Orientation

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [_metadataObjectTypes containsObject:current.type]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *)current stringValue];
            
            if ([self.delegate respondsToSelector:@selector(readerDidScanWithResult:)]) {
                [self.delegate readerDidScanWithResult:scannedResult];
            }
            
            break;
        }
    }
}

@end
