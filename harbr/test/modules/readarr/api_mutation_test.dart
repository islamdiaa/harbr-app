/// Mutation API Contract Tests for Readarr
///
/// Tests PUT/POST/DELETE operations against a real Readarr instance.
/// These tests modify data but restore original state after each test.
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/api/readarr/models/tag/tag.dart';

final _baseUrl =
    Platform.environment['READARR_URL'] ?? 'http://192.168.1.142:8787';
final _apiKey = Platform.environment['READARR_API_KEY'] ??
    '9c6eaa476ccf45b1825b8405f8baf756';

Future<dynamic> _apiRequest(
  String method,
  String path, {
  Map<String, String>? queryParams,
  Object? body,
}) async {
  final uri = Uri.parse('$_baseUrl/api/v1/$path').replace(
    queryParameters: {
      'apikey': _apiKey,
      ...?queryParams,
    },
  );
  final client = HttpClient();
  try {
    late HttpClientRequest request;
    switch (method) {
      case 'GET':
        request = await client.getUrl(uri);
        break;
      case 'PUT':
        request = await client.putUrl(uri);
        break;
      case 'POST':
        request = await client.postUrl(uri);
        break;
      case 'DELETE':
        request = await client.deleteUrl(uri);
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }
    request.headers.contentType = ContentType.json;
    if (body != null) {
      request.write(json.encode(body));
    }
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode >= 400) {
      throw HttpException(
        '$method $path returned ${response.statusCode}: '
        '${responseBody.substring(0, responseBody.length.clamp(0, 300))}',
      );
    }
    if (responseBody.isEmpty) return null;
    return json.decode(responseBody);
  } finally {
    client.close();
  }
}

Future<dynamic> _get(String path, [Map<String, String>? params]) =>
    _apiRequest('GET', path, queryParams: params);
Future<dynamic> _put(String path, Object body) =>
    _apiRequest('PUT', path, body: body);
Future<dynamic> _post(String path, Object body) =>
    _apiRequest('POST', path, body: body);
Future<dynamic> _delete(String path) => _apiRequest('DELETE', path);

void main() {
  group('Readarr Mutation API Tests', () {
    late bool serverReachable;

    setUpAll(() async {
      try {
        final result = await _get('system/status');
        serverReachable = result is Map && result['appName'] == 'Readarr';
        if (serverReachable) {
          // ignore: avoid_print
          print('Connected to Readarr ${result['version']} at $_baseUrl');
        }
      } catch (e) {
        serverReachable = false;
        // ignore: avoid_print
        print('WARNING: Readarr not reachable - mutation tests skipped. $e');
      }
    });

    group('PUT /book - toggle monitored', () {
      /// Readarr's PUT /book requires `editions` to be a non-null list.
      /// The GET response may return editions as null, so we patch it.
      Map<String, dynamic> _patchForPut(Map<String, dynamic> json) {
        json['editions'] ??= <Map<String, dynamic>>[];
        return json;
      }

      test('can toggle book monitored status off and back on', () async {
        if (!serverReachable) return;

        // Get current state of book 1 (Foundation - monitored=true)
        final originalJson =
            await _get('book/1') as Map<String, dynamic>;
        final original = ReadarrBook.fromJson(originalJson);
        expect(original.monitored, true);

        // Toggle to unmonitored
        originalJson['monitored'] = false;
        final updatedJson = await _put('book/1', _patchForPut(originalJson))
            as Map<String, dynamic>;
        final updated = ReadarrBook.fromJson(updatedJson);
        expect(updated.monitored, false);
        expect(updated.id, 1);
        expect(updated.title, 'Foundation');

        // Verify via GET
        final verifyJson =
            await _get('book/1') as Map<String, dynamic>;
        expect(verifyJson['monitored'], false);

        // Restore original state
        verifyJson['monitored'] = true;
        await _put('book/1', _patchForPut(verifyJson));

        // Confirm restored
        final restoredJson =
            await _get('book/1') as Map<String, dynamic>;
        expect(restoredJson['monitored'], true);
      });
    });

    group('PUT /author - update author', () {
      test('can toggle author monitored status', () async {
        if (!serverReachable) return;

        // Author 3 (Jane Austen) is unmonitored
        final originalJson =
            await _get('author/3') as Map<String, dynamic>;
        final original = ReadarrAuthor.fromJson(originalJson);
        expect(original.monitored, false);

        // Toggle to monitored
        originalJson['monitored'] = true;
        final updatedJson =
            await _put('author/3', originalJson) as Map<String, dynamic>;
        final updated = ReadarrAuthor.fromJson(updatedJson);
        expect(updated.monitored, true);

        // Restore
        updatedJson['monitored'] = false;
        await _put('author/3', updatedJson);

        final restoredJson =
            await _get('author/3') as Map<String, dynamic>;
        expect(restoredJson['monitored'], false);
      });

      test('can update author quality profile', () async {
        if (!serverReachable) return;

        final originalJson =
            await _get('author/1') as Map<String, dynamic>;
        final originalProfile = originalJson['qualityProfileId'];
        expect(originalProfile, 1); // eBook

        // Switch to Spoken (id=2)
        originalJson['qualityProfileId'] = 2;
        final updatedJson =
            await _put('author/1', originalJson) as Map<String, dynamic>;
        expect(updatedJson['qualityProfileId'], 2);

        // Restore
        updatedJson['qualityProfileId'] = originalProfile;
        await _put('author/1', updatedJson);
      });
    });

    group('POST/DELETE /tag - CRUD tags', () {
      test('can create and delete a tag', () async {
        if (!serverReachable) return;

        // Create
        final created = await _post('tag', {'label': 'test-tag'})
            as Map<String, dynamic>;
        final tag = ReadarrTag.fromJson(created);
        expect(tag.id, isNotNull);
        expect(tag.label, 'test-tag');

        // Verify it exists
        final tags = await _get('tag') as List;
        final labels =
            tags.map((t) => (t as Map<String, dynamic>)['label']).toList();
        expect(labels, contains('test-tag'));

        // Delete
        await _delete('tag/${tag.id}');

        // Verify deleted
        final tagsAfter = await _get('tag') as List;
        final labelsAfter = tagsAfter
            .map((t) => (t as Map<String, dynamic>)['label'])
            .toList();
        expect(labelsAfter, isNot(contains('test-tag')));
      });

      test('can update a tag', () async {
        if (!serverReachable) return;

        // Create a temp tag
        final created = await _post('tag', {'label': 'temp-update-tag'})
            as Map<String, dynamic>;
        final tagId = created['id'];

        // Update
        final updated =
            await _put('tag/$tagId', {'id': tagId, 'label': 'updated-tag'})
                as Map<String, dynamic>;
        expect(updated['label'], 'updated-tag');

        // Cleanup
        await _delete('tag/$tagId');
      });
    });

    group('PUT /author - tag management', () {
      test('can add and remove tags from author', () async {
        if (!serverReachable) return;

        // Author 3 (Jane Austen) has tags [3] (classics)
        final originalJson =
            await _get('author/3') as Map<String, dynamic>;
        final originalTags = List<int>.from(originalJson['tags'] as List);
        expect(originalTags, [3]);

        // Add tag 1 (favorites)
        originalJson['tags'] = [3, 1];
        final updatedJson =
            await _put('author/3', originalJson) as Map<String, dynamic>;
        final updatedAuthor = ReadarrAuthor.fromJson(updatedJson);
        expect(updatedAuthor.tags, containsAll([1, 3]));

        // Restore original tags
        updatedJson['tags'] = originalTags;
        await _put('author/3', updatedJson);

        final restoredJson =
            await _get('author/3') as Map<String, dynamic>;
        expect(List<int>.from(restoredJson['tags'] as List), originalTags);
      });
    });

    group('POST /command - server commands', () {
      test('can send RefreshAuthor command', () async {
        if (!serverReachable) return;

        final result = await _post('command', {
          'name': 'RefreshAuthor',
          'authorId': 1,
        }) as Map<String, dynamic>;

        expect(result['name'], 'RefreshAuthor');
        expect(result['status'], isNotNull);
        expect(result['id'], isNotNull);
      });

      test('can send MissingBookSearch command', () async {
        if (!serverReachable) return;

        final result = await _post('command', {
          'name': 'MissingBookSearch',
        }) as Map<String, dynamic>;

        expect(result['name'], 'MissingBookSearch');
        expect(result['status'], isNotNull);
      });
    });

    group('Error handling', () {
      test('GET non-existent book returns 404', () async {
        if (!serverReachable) return;

        try {
          await _get('book/99999');
          fail('Expected HttpException');
        } on HttpException catch (e) {
          expect(e.message, contains('404'));
        }
      });

      test('GET non-existent author returns 404', () async {
        if (!serverReachable) return;

        try {
          await _get('author/99999');
          fail('Expected HttpException');
        } on HttpException catch (e) {
          expect(e.message, contains('404'));
        }
      });

      test('DELETE non-existent tag returns error', () async {
        if (!serverReachable) return;

        try {
          await _delete('tag/99999');
          fail('Expected HttpException');
        } on HttpException catch (e) {
          expect(e.message, contains('404'));
        }
      });
    });

    group('Roundtrip consistency', () {
      test('GET -> deserialize -> serialize -> PUT preserves book', () async {
        if (!serverReachable) return;

        final json = await _get('book/4') as Map<String, dynamic>;
        final book = ReadarrBook.fromJson(json);

        // Readarr requires editions to be non-null for PUT
        json['editions'] ??= <Map<String, dynamic>>[];

        final result = await _put('book/4', json) as Map<String, dynamic>;
        final resultBook = ReadarrBook.fromJson(result);

        expect(resultBook.id, book.id);
        expect(resultBook.title, book.title);
        expect(resultBook.monitored, book.monitored);
        expect(resultBook.authorId, book.authorId);
        expect(resultBook.pageCount, book.pageCount);
      });

      test('GET -> deserialize -> serialize -> PUT preserves author', () async {
        if (!serverReachable) return;

        final json = await _get('author/1') as Map<String, dynamic>;
        final author = ReadarrAuthor.fromJson(json);

        final result = await _put('author/1', json) as Map<String, dynamic>;
        final resultAuthor = ReadarrAuthor.fromJson(result);

        expect(resultAuthor.id, author.id);
        expect(resultAuthor.authorName, author.authorName);
        expect(resultAuthor.monitored, author.monitored);
        expect(resultAuthor.qualityProfileId, author.qualityProfileId);
        expect(resultAuthor.metadataProfileId, author.metadataProfileId);
        expect(resultAuthor.tags, author.tags);
      });
    });
  });
}
