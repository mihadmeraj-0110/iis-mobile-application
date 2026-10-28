import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iis_mobile_application/src/application/providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('onboarding starts incomplete when no completion is saved', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(onboardingProvider.future), isFalse);
  });

  test('completing onboarding persists the completion flag', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(onboardingProvider.future);
    await container.read(onboardingProvider.notifier).complete();

    expect(container.read(onboardingProvider).value, isTrue);
    expect(
      (await SharedPreferences.getInstance()).getBool('onboarding_complete'),
      isTrue,
    );
  });

  test('onboarding restores its saved completion flag', () async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(onboardingProvider.future), isTrue);
  });
}
