import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SetStatus { initial, inProgress, finished, breakTime }

class SetStatusNotifier extends StateNotifier<SetStatus> {
  SetStatusNotifier() : super(SetStatus.initial);

  int _currentSet = 0;
  int _additionalTime = 0;

  int get currentSet => _currentSet;
  int get additionalTime => _additionalTime;

  void startSet() {
    _currentSet++;
    _additionalTime = 0;
    state = SetStatus.inProgress;
  }

  void finishSet() {
    state = SetStatus.finished;
  }

  void startBreak() {
    state = SetStatus.breakTime;
  }

  void reset() {
    state = SetStatus.initial;
  }

  void extendBreak() {
    _additionalTime = 30; // Add 30 seconds to the break
    state = SetStatus.breakTime;
  }

  Future<void> timerFinished() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Introduce a 1-second delay
    if (state == SetStatus.inProgress || state == SetStatus.breakTime) {
      finishSet();
    }
  }
}

final setStatusProvider =
    StateNotifierProvider<SetStatusNotifier, SetStatus>((ref) {
  return SetStatusNotifier();
});

final timerProvider = StreamProvider.autoDispose<int>((ref) {
  final setStatusNotifier = ref.watch(setStatusProvider.notifier);
  final setStatus = ref.watch(setStatusProvider);

  int totalTime;

  if (setStatus == SetStatus.inProgress) {
    totalTime = 30; // Set initial 3 seconds for workout
  } else if (setStatus == SetStatus.breakTime) {
    totalTime =
        setStatusNotifier.additionalTime; // Only use additional time for break
  } else {
    return const Stream.empty();
  }

  return Stream.periodic(const Duration(seconds: 1), (count) {
    final remainingTime = totalTime - count;
    if (remainingTime == 0) {
      setStatusNotifier.timerFinished();
    }
    return remainingTime;
  }).take(totalTime + 1);
});
