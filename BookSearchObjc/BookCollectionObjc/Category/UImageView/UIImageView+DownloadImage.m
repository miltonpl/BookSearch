//
//  UIImageView+DownloadImage.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "UIImageView+DownloadImage.h"

@implementation UIImageView (DownloadImage)

- (void)downloadImage:(NSURL * _Nonnull ) url {
    
    if (@available(iOS 13.0, *)) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleMedium];
        indicator.color = [UIColor redColor];
        [indicator startAnimating];
        [indicator setCenter: self.center];
        [self addSubview:indicator];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            
            NSData * data = [[NSData alloc] initWithContentsOfURL:url];
            if(!data) {
                [indicator stopAnimating];
                [indicator removeFromSuperview];
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                [indicator removeFromSuperview];
                self.image = [UIImage imageWithData: data];

            });
        });
    } else {
        
        NSLog(@"// Fallback on earlier versions");
    }
}

@end
