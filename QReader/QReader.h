//
//  QReader.h
//  QReader, https://github.com/rsimenok/QReader
//
//  Created by Roman Simenok on 11/28/17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "QReaderDelegate.h"

/**
 * Reader object base on the `AVCaptureDevice` to read / scan 1D and 2D codes.
 */
@interface QReader : NSObject

/**
 Initializes a reader with a list of metadata object types

 @param metadataObjectTypes An array of strings identifying the types of metadata objects to process.
 */
- (nonnull id)initWithMetadataObjectTypes:(nonnull NSArray<AVMetadataObjectType> *)metadataObjectTypes;

/**
 Creates a reader with a list of metadata object types.

 @param metadataObjectTypes An array of strings identifying the types of metadata objects to process.
 */
+ (nonnull instancetype)readerWithMetadataObjectTypes:(nonnull NSArray<AVMetadataObjectType> *)metadataObjectTypes;

#pragma mark - Checking the Reader Availabilities

/**
 Checking whether the reader is available with the current device.

 @return a Boolean value indicating whether the reader is available.
 */
+ (BOOL)isAvailable;

/**
 Checking whether the given metadata object types are supported by the current device.

 @param metadataObjectTypes An array of strings identifying the types of metadata objects to process.
 @return a Boolean value indicating whether the given metadata object types are supported by the current device.
 */
+ (BOOL)supportsMetadataObjectTypes:(nonnull NSArray<AVMetadataObjectType> *)metadataObjectTypes;

#pragma mark - Checking the Metadata Items Types

/**
 An array of strings identifying the types of metadata objects to process.
 */
@property (strong, nonatomic, readonly) NSArray<AVMetadataObjectType> * _Nonnull metadataObjectTypes;

#pragma mark - Viewing the Camera

/**
 CALayer that you use to display video as it is being captured by an input device.
 */
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer * _Nonnull previewLayer;

#pragma maek - QReader Delegate

/**
 The object that acts as the delegate of the receiving QRCode.
 */
@property (weak, nonatomic) id<QReaderDelegate> __nullable delegate;

#pragma mark - Controlling the Reader

/**
 Starts scanning the codes.
 */
- (void)startScanning;

/**
 Stops scanning the codes.
 */
- (void)stopScanning;

/**
 Checking whether the session is currently running.

 @return a Boolean value indicating whether the session is currently running.
 */
- (BOOL)isRunning;

/**
 Toggles torch.
 */
- (void)toggleTorch;

/**
 Checking whether the torch is currently enabled.

 @return a Boolean value indicating whether the torch is currently enabled.
 */
- (BOOL)isTorchEnabled;

#pragma mark - Getting Inputs and Outputs

/**
 Accessing to the `AVCaptureDeviceInput` object representing the default device input.
 */
@property (readonly) AVCaptureDeviceInput * _Nonnull defaultDeviceInput;

/**
 Accessing to the `AVCaptureMetadataOutput` object. It allows you to configure the scanner to restrict the area of the scan to the overlay one for example.
 */
@property (readonly) AVCaptureMetadataOutput * _Nonnull metadataOutput;

#pragma mark - Managing the Orientation

/**
 Returns the video orientation correspongind to the given interface orientation.
 
 @param interfaceOrientation An interface orientation.
 @return the video orientation correspongind to the given interface orientation.
 */
+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
