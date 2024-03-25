import 'dart:math';

List<T> shuffleList<T>(List<T> list, Random random) {
  for (int i = list.length - 1; i > 0; i--) {
    int n = random.nextInt(i + 1);
    T temp = list[i];
    list[i] = list[n];
    list[n] = temp;
  }
  return list;
}

class RandomList {
  final int length;
  final Random random;

  RandomList(this.length, this.random);

  List<int> generate() {
    List<int> list = List<int>.generate(length, (index) => index);
    return shuffleList(list, random);
  }
}