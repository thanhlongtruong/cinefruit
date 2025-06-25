import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedBackground extends ConsumerWidget {
  final Widget child;
  const FixedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgApp = ref.read(backgroundAppProvider.notifier).state;

    return Positioned.fill(
      child: Stack(
        // children: backgroundApp(bgApp),
      ),
    );
  }
}
