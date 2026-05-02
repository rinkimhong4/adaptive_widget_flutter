class Helper {
  static String formatText4(String text, {int wordsPerLine = 4}) {
    // length word
    final words = text.split(' ');
    final buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);
      if ((i + 1) % wordsPerLine == 0 && i != words.length - 1) {
        buffer.write('\n');
      } else {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }

  static String formatText2(String text, {int wordsPerLine = 2}) {
    // length word
    final words = text.split(' ');
    final buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);
      if ((i + 1) % wordsPerLine == 0 && i != words.length - 1) {
        buffer.write('\n');
      } else {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }
}
