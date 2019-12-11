import 'package:flutter_test/flutter_test.dart';
import 'package:holybible/models/version.dart';

void main() {
  test("version model", () {
    Version target = Version.fromMap({
      'vcode': 'NIV',
      'name': 'NIV'
    });

    expect(target.vcode, equals('NIV'));
  });
}
