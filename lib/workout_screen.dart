import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymstory/provider/set_status.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsyncValue = ref.watch(timerProvider);
    final setStatus = ref.watch(setStatusProvider);
    final setStatusNotifier = ref.watch(setStatusProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current set: ${setStatusNotifier.currentSet}',
              style: const TextStyle(fontSize: 24),
            ),
            if (setStatus == SetStatus.inProgress) ...[
              timerAsyncValue.when(
                data: (time) => Text(
                  'Time Remaining: $time seconds',
                  style: const TextStyle(fontSize: 24),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              ElevatedButton(
                onPressed: () {
                  setStatusNotifier.finishSet();
                },
                child: const Text('Finish Set'),
              ),
            ] else if (setStatus == SetStatus.finished) ...[
              const Text(
                'Break Time',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                  setStatusNotifier.extendBreak(); // Extend the current break
                },
                child: Text('Extend Break by 30s'),
              ),
              ElevatedButton(
                onPressed: () {
                  setStatusNotifier.reset();
                  setStatusNotifier.startSet(); // Restart the set and timer
                },
                child: const Text('Start Another Set'),
              ),
            ] else if (setStatus == SetStatus.breakTime) ...[
              timerAsyncValue.when(
                data: (time) => Text(
                  'Time Remaining: $time seconds',
                  style: const TextStyle(fontSize: 24),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              ElevatedButton(
                onPressed: () {
                  setStatusNotifier.finishSet();
                },
                child: const Text('Finish Set'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
