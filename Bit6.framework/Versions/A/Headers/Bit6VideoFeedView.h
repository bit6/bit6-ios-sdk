//
//  Bit6VideoFeedView.h
//  Bit6
//
//  Created by Carlos Thurber on 12/05/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! UIView to render a video feed during a call. */
@interface Bit6VideoFeedView : UIView

/*! Yes is the view is rendering the local video feed. */
@property (nonatomic, readonly) BOOL isLocal;

@end
