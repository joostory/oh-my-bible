import 'package:google_fonts/google_fonts.dart';

const List<Map<String, dynamic>> FONT_SIZE_LIST = [
  {'label': '텍스트 작게', 'value': 14.0},
  {'label': '텍스트 기본크기', 'value': 16.0},
  {'label': '텍스트 크게', 'value': 20.0},
  {'label': '텍스트 아주 크게', 'value': 24.0},
];

const List<Map<String, String>> FONT_FAMILY_LIST = [
  {'label': '고딕', 'value': 'notosans'},
  {'label': '명조', 'value': 'notoserif'},
  {'label': 'SunFlower', 'value': 'sunflower'},
  {'label': 'Stylish', 'value': 'stylish'},
  {'label': 'Poor Story', 'value': 'poorStory'},
  {'label': '연성체', 'value': 'yeonsung'},
];

String toGoogleFontFamily(String fontFamilyValue) {
  switch (fontFamilyValue) {
    case 'sunflower':
      return GoogleFonts.sunflower().fontFamily;
    case 'stylish':
      return GoogleFonts.stylish().fontFamily;
    case 'poorStory':
      return GoogleFonts.poorStory().fontFamily;
    case 'yeonsung':
      return GoogleFonts.yeonSung().fontFamily;
    case 'notoserif':
      return "NotoSerifKR";
    case 'notosans':
    default:
      return GoogleFonts.notoSans().fontFamily;
  }
}
