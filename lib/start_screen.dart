import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymstory/provider/set_status.dart';
import 'package:gymstory/workout_screen.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Workout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(setStatusProvider.notifier).startSet();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutScreen()),
            );
          },
          child: const Text('Start Set'),
        ),
      ),
    );
  }
}
