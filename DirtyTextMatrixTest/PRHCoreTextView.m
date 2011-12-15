//
//  PRHCoreTextView.m
//  DirtyTextMatrixTest
//
//  Created by Peter Hosey on 2011-12-14.
//

#import "PRHCoreTextView.h"

@implementation PRHCoreTextView
{
	NSAttributedString *text;
}

- (id) initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self->text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"This should be Georgia 14-pt.", /*comment*/ nil)
			attributes:[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Georgia" size:14.0] forKey:NSFontAttributeName]];
	}

	return self;
}

- (void) drawRect:(NSRect)dirtyRect {
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

	CGAffineTransform textTransform = CGContextGetTextMatrix(context);
	NSLog(@"Text transform:\n"
		@"[%g,\t%g,\t%g\n"
		@" %g,\t%g,\t%g\n"
		@" %g,\t%g,\t%g]",
		textTransform.a, textTransform.b, 0.0,
		textTransform.c, textTransform.d, 0.0,
		textTransform.tx, textTransform.ty, 1.0
		);

	//If you uncomment this, the text draws correctly.
//	CGContextSetTextMatrix(context, CGAffineTransformIdentity);

	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self->text);
	if (framesetter) {
		NSRect bounds = [self bounds];
		CGPathRef path = CGPathCreateWithRect(bounds, /*transform*/ NULL);
		if (path) {
			CTFrameRef frame = CTFramesetterCreateFrame(framesetter, (CFRange){ 0, [self->text length] }, path, /*frameAttributes*/ nil);

			if (frame) {
				CTFrameDraw(frame, context);

				CFRelease(frame);
			}

			CFRelease(path);
		}

		CFRelease(framesetter);
	}
}

@end
