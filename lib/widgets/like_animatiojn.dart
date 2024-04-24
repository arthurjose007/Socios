import 'package:flutter/cupertino.dart';

class AnimationLike extends StatefulWidget {
  final Widget child;
  final bool isAnimationok;
  final Duration duration;
  final bool smallliike;
  final VoidCallback? onend;
  const AnimationLike(
      {super.key,
      required this.child,
      required this.isAnimationok,
      this.duration = const Duration(microseconds: 150),
      this.smallliike = false,
      this.onend});

  @override
  State<AnimationLike> createState() => _AnimationLikeState();
}

class _AnimationLikeState extends State<AnimationLike>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: Duration(microseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimationLike oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimationok != oldWidget.isAnimationok) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimationok || widget.smallliike) {
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(const Duration(microseconds: 200));
      if (widget.onend != null) {
        widget.onend!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
