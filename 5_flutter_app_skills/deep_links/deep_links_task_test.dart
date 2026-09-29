import 'package:flutter_test/flutter_test.dart';

import 'deep_links_task.dart';

void main() {
  group('Deep links helpers', () {
    test('isAppDeepLink', () {
      expect(isAppDeepLink(Uri.parse('myapp://profile/1')), isTrue);
      expect(isAppDeepLink(Uri.parse('https://example.com/products/2')), isTrue);
      expect(
        isAppDeepLink(Uri.parse('https://www.example.com/login')),
        isTrue,
      );
      expect(isAppDeepLink(Uri.parse('https://evil.com/login')), isFalse);
      expect(isAppDeepLink(Uri.parse('http://example.com/login')), isFalse);
    });

    test('parseAppLink и locationOf', () {
      final link = parseAppLink(
        Uri.parse('https://example.com/profile/1?tab=posts'),
      );

      expect(link.scheme, 'https');
      expect(link.host, 'example.com');
      expect(link.path, '/profile/1');
      expect(link.queryParams['tab'], 'posts');
      expect(locationOf(link), '/profile/1?tab=posts');

      final root = parseAppLink(Uri.parse('myapp://'));
      expect(root.path, '/');
      expect(locationOf(root), '/');
    });

    test('patternSegments и matchPathParams', () {
      expect(patternSegments('/'), isEmpty);
      expect(patternSegments('/profile/:id'), ['profile', ':id']);

      expect(
        matchPathParams('/profile/:id', '/profile/42'),
        {'id': '42'},
      );
      expect(matchPathParams('/profile/:id', '/profile'), isNull);
      expect(matchPathParams('/login', '/login'), isEmpty);
      expect(matchPathParams('/login', '/logout'), isNull);
    });

    test('matchRoute', () {
      final profile = matchRoute(
        parseAppLink(Uri.parse('https://example.com/profile/7?tab=bio')),
      );
      expect(profile?.name, 'profile');
      expect(profile?.pathParams['id'], '7');
      expect(profile?.queryParams['tab'], 'bio');

      expect(
        matchRoute(parseAppLink(Uri.parse('https://example.com/unknown'))),
        isNull,
      );
    });

    test('auth redirect helpers', () {
      expect(requiresAuth('profile'), isTrue);
      expect(requiresAuth('login'), isFalse);

      expect(
        loginRedirectLocation('/profile/1'),
        '/login?redirect=%2Fprofile%2F1',
      );

      final login = parseAppLink(
        Uri.parse('https://example.com/login?redirect=%2Fproducts%2F3'),
      );
      expect(postLoginLocation(login), '/products/3');
      expect(
        postLoginLocation(parseAppLink(Uri.parse('https://example.com/login'))),
        '/',
      );
    });

    test('requirePathId, normalizePath, resolveDeepLink', () {
      final match = matchRoute(
        parseAppLink(Uri.parse('myapp://products/99')),
      )!;
      expect(requirePathId(match), '99');
      expect(
        () => requirePathId(
          const RouteMatch(name: 'home', pathParams: {}, queryParams: {}),
        ),
        throwsFormatException,
      );

      expect(normalizePath('/profile/1/'), '/profile/1');
      expect(normalizePath('/'), '/');

      final resolved = resolveDeepLink(
        Uri.parse('https://example.com/profile/5/?x=1'),
      );
      expect(resolved?.name, 'profile');
      expect(resolved?.pathParams['id'], '5');
      expect(resolved?.queryParams['x'], '1');

      expect(resolveDeepLink(Uri.parse('https://evil.com/profile/1')), isNull);
    });
  });
}
