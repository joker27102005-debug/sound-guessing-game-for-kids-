import 'dart:math';

class RandomGenerator {
  static int getRandomIndex(int length) {
    final random = Random();
    return random.nextInt(length);
  }
}
