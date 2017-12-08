
#ifndef GIPHY_MACROS_H
#define GIPHY_MACROS_H

#pragma mark - Block helpers

#define BlockSafeRun(block_, ...) do { if ((block_) != NULL) (block_)(__VA_ARGS__); } while (NO)
#define BlockSafeRunEx(defaultValue_, block_, ...) (((block_) != NULL) ? (block_)(__VA_ARGS__) : (defaultValue_))
#define BlockSafeRunOnTargetQueue(queue, block, ...) do { if ((block) != NULL) dispatch_async(queue, ^{ (block)(__VA_ARGS__); }); } while (0)
#define BlockSafeRunOnMainQueue(block, ...) BlockSafeRunOnTargetQueue(dispatch_get_main_queue(), (block), __VA_ARGS__)

#if __has_feature(objc_arc)
#define BlockWeakObject(o) __typeof__(o) __weak
#define BlockWeakSelf BlockWeakObject(self)
#define BlockStrongObject(o) __typeof__(o) __strong
#define BlockStrongSelf BlockStrongObject(self)
#define WeakifySelf BlockWeakSelf ___weakSelf___ = self; do {} while (0)
#define StrongifySelf BlockStrongSelf self = ___weakSelf___; do {} while (0)

#endif // __has_feature(objc_arc)

#endif // GIPHY_MACROS_H
