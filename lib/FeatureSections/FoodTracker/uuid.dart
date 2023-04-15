import 'dart:math';

class Uuid {
  // Declare a private instance of the Random class for generating random numbers
  final Random _random = Random();

  // Define a method to generate a Version 4 UUID
  String generateV4() {
    // Determine the special value to use in the UUID
    final int special = 8 + _random.nextInt(4);

    // Construct the UUID string from its components
    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-' // 8 hex digits
        '${_bitsDigits(16, 4)}-' // 4 hex digits
        '4${_bitsDigits(12, 3)}-' // 3 hex digits
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-' // 1 and 3 hex digits
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}'; // 12 hex digits
  }

  // Generate a random bit sequence of specified length and convert it to a string of hex digits
  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  // Generate a random integer with the specified number of bits
  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  // Convert an integer to a string of hex digits with the specified minimum length
  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}