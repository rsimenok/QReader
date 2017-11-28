//
//  QReaderDelegate.h
//  QReader, https://github.com/rsimenok/QReader
//
//  Created by Roman Simenok on 11/28/17. All rights reserved.
//

/**
 This protocol defines delegate methods for objects that implements the `QReaderDelegate`.
 The methods of the protocol allow the delegate to be notified when the reader did scan result
 and or when the user wants to stop to read some QRCodes.
 */
@protocol QReaderDelegate <NSObject>

/**
 Tells the delegate that the reader did scan a QRCode and stop scanning.

 @param result The content of the QRCode as a string.
 */
- (void)readerDidScanWithResult:(NSString *)result;

@optional

/**
  Tells the delegate that the user wants to stop scanning QRCodes.
 */
- (void)readerDidCancel;

@end
