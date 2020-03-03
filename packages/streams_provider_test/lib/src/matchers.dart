// ignore: implementation_imports
import 'package:test_api/src/frontend/async_matcher.dart';
import 'package:flutter_test/flutter_test.dart';


Matcher doesNotEmits([Duration delay]) {
  return _DoesNotEmits(delay);
}

class _DoesNotEmits extends AsyncMatcher {
  const _DoesNotEmits([this.delay = const Duration(milliseconds: 100)]);

  //
  final Duration delay;
  @override
  Description describe(Description description) => description.add("<empty>");

  @override
  matchAsync(item) async {
    assert(item is Stream);
    dynamic res;
    item.listen((data) {
      res = data;
    });

    await Future.delayed(Duration(milliseconds: 100));
    if (res == null) return null;

    return "emitted $res";
  }

}