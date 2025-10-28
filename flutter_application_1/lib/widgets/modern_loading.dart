import 'package:flutter/material.dart';

class ModernLoading extends StatefulWidget {
  final String message;
  final Color? color;

  const ModernLoading({super.key, this.message = 'Yükleniyor...', this.color});

  @override
  State<ModernLoading> createState() => _ModernLoadingState();
}

class _ModernLoadingState extends State<ModernLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [color.withAlpha(26), color, color.withAlpha(26)],
                  stops: const [0.0, 0.5, 1.0],
                  transform: GradientRotation(_animation.value * 2 * 3.14159),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.navigation_rounded, color: color, size: 24),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          widget.message,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
