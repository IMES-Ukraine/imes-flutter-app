import 'dart:io';

import 'package:imes/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('images assets test', () {
    expect(true, File(Images.instruction).existsSync());
    expect(true, File(Images.telegram).existsSync());
    expect(true, File(Images.loginLogo).existsSync());
    expect(true, File(Images.token).existsSync());
    expect(true, File(Images.twoBars).existsSync());
    expect(true, File(Images.viber).existsSync());
    expect(true, File(Images.bottle).existsSync());
    expect(true, File(Images.history).existsSync());
    expect(true, File(Images.messenger).existsSync());
    expect(true, File(Images.weightIcon).existsSync());
    expect(true, File(Images.whatsup).existsSync());
    expect(true, File(Images.clock).existsSync());
    expect(true, File(Images.union).existsSync());
    expect(true, File(Images.facebook).existsSync());
    expect(true, File(Images.camera).existsSync());
  });
}
