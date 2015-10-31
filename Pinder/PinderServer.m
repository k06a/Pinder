//
//  PinderServer.m
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "NSMutableURLRequest+Parameters.h"
#import "PinderServer.h"

@interface PinderServer () <UIWebViewDelegate>

@property (nonatomic, strong) id<UIWebViewDelegate> oldWebViewDelegate;
@property (nonatomic, strong) void(^loginCompletion)(NSString *user_id, NSString *server_token);
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation PinderServer

#pragma mark - Properties

- (NSURLSession *)session
{
    if (_session == nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _session;
}

- (NSString *)user_id
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
}

- (void)setUser_id:(NSString *)user_id
{
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)server_token
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"server_token"];
}

- (void)setServer_token:(NSString *)server_token
{
    [[NSUserDefaults standardUserDefaults] setObject:server_token forKey:@"server_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Public

+ (instancetype)sharedServer
{
    return [self sharedServerWithDelegate:nil];
}

+ (instancetype)sharedServerWithDelegate:(id<PinderServerDelegate>)delegate
{
    static PinderServer *server;
    if (delegate == nil && server.delegate == nil)
        @throw [NSException exceptionWithName:@"PinderServerException" reason:@"Need to call sharedServerWithDelegate with non nil argument" userInfo:nil];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[PinderServer alloc] init];
        server.delegate = delegate;
    });
    return server;
}

- (void)loginInView:(UIWebView *)webView completion:(void(^)(NSString *user_id, NSString *server_token))completion
{
    self.loginCompletion = [completion copy];
    self.oldWebViewDelegate = webView.delegate;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://vk-hackathon.tk/api/vk/auth-url"]]];
}

/*
- (void)login:(void(^)(NSString *user_id, NSString *server_token))completion
{
    [self.session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://vk-hackathon.tk/api/vk/auth-url"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
            return [self.delegate showError:error];
        
        
    }];
*/

#pragma mark - Web View Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.oldWebViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
        [self.oldWebViewDelegate webView:webView didFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"URL = %@", request.URL);
    
    if ([request.URL.host isEqualToString:@"pinder-success.com"]) {
        webView.delegate = self.oldWebViewDelegate;
        if (self.loginCompletion)
            self.loginCompletion(request.parameters[@"user_id"],
                                 request.parameters[@"hash"]);
        return NO;
    }
    
    if ([request.URL.host isEqualToString:@"pinder-error.com"]) {
        webView.delegate = self.oldWebViewDelegate;
        [self.delegate showErrorMessage:request.parameters[@"error"]];
        if (self.loginCompletion)
            self.loginCompletion(nil,nil);
        return NO;
    }
    
    if ([self.oldWebViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
        return [self.oldWebViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.oldWebViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
        return [self.oldWebViewDelegate webViewDidFinishLoad:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.oldWebViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
        return [self.oldWebViewDelegate webViewDidStartLoad:webView];
}

@end