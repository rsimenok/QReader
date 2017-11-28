//
//  QReaderViewController.h
//  QReader, https://github.com/rsimenok/QReader
//
//  Created by Roman Simenok on 11/28/17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QReader.h"

@interface QReaderViewController : UIViewController <QReaderDelegate>

/**
 Initializes a reader view controller with a list of metadata object types.
 
 @param metadataObjectTypes An array of strings identifying the types of metadata objects to process.
 */
- (nonnull instancetype)initWithMetadataObjectTypes:(nonnull NSArray<AVMetadataObjectType> *)metadataObjectTypes;

/**
 Creates a reader view controller with a list of metadata object types.
 
 @param metadataObjectTypes An array of strings identifying the types of metadata objects to process.
 */
+ (nonnull instancetype)readerWithMetadataObjectTypes:(nonnull NSArray<AVMetadataObjectType> *)metadataObjectTypes;

/**
 Start scanning the codes.
 */
- (void)startScanning;

/**
 Stops scanning the codes.
 */
- (void)stopScanning;

#pragma maek - QReader Delegate

/**
 The object that acts as the delegate of the receiving QRCode.
 */
@property (weak, nonatomic) id<QReaderDelegate> __nullable delegate;

@end
