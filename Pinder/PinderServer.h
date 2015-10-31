//
//  PinderServer.h
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol PinderServerDelegate <NSObject>

- (void)showError:(NSError *)error;
- (void)showErrorMessage:(NSString *)errorMessage;
- (void)showSuccessMessage:(NSString *)successMessage;

@end

//

@interface PinderServer : NSObject

@property (nonatomic, weak) id<PinderServerDelegate> delegate;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *server_token;

+ (instancetype)sharedServer;
+ (instancetype)sharedServerWithDelegate:(id<PinderServerDelegate>)delegate;

- (void)loginInView:(UIWebView *)webView completion:(void(^)(NSString *user_id, NSString *server_token))completion;

@end
