library readarr;

import 'package:dio/dio.dart';
import 'package:harbr/api/readarr/controllers.dart';

class ReadarrAPI {
  ReadarrAPI._internal({
    required this.httpClient,
    required this.author,
    required this.book,
    required this.bookLookup,
    required this.command,
    required this.history,
    required this.metadataProfile,
    required this.profile,
    required this.queue,
    required this.release,
    required this.rootFolder,
    required this.system,
    required this.tag,
    required this.wanted,
  });

  factory ReadarrAPI({
    required String host,
    required String apiKey,
    Map<String, dynamic>? headers,
    bool followRedirects = true,
    int maxRedirects = 5,
  }) {
    Dio _dio = Dio(
      BaseOptions(
        baseUrl: host.endsWith('/') ? '${host}api/v1/' : '$host/api/v1/',
        queryParameters: {'apikey': apiKey},
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: headers,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
      ),
    );
    return ReadarrAPI._internal(
      httpClient: _dio,
      author: ReadarrControllerAuthor(_dio),
      book: ReadarrControllerBook(_dio),
      bookLookup: ReadarrControllerBookLookup(_dio),
      command: ReadarrControllerCommand(_dio),
      history: ReadarrControllerHistory(_dio),
      metadataProfile: ReadarrControllerMetadataProfile(_dio),
      profile: ReadarrControllerProfile(_dio),
      queue: ReadarrControllerQueue(_dio),
      release: ReadarrControllerRelease(_dio),
      rootFolder: ReadarrControllerRootFolder(_dio),
      system: ReadarrControllerSystem(_dio),
      tag: ReadarrControllerTag(_dio),
      wanted: ReadarrControllerWanted(_dio),
    );
  }

  factory ReadarrAPI.from({required Dio client}) {
    return ReadarrAPI._internal(
      httpClient: client,
      author: ReadarrControllerAuthor(client),
      book: ReadarrControllerBook(client),
      bookLookup: ReadarrControllerBookLookup(client),
      command: ReadarrControllerCommand(client),
      history: ReadarrControllerHistory(client),
      metadataProfile: ReadarrControllerMetadataProfile(client),
      profile: ReadarrControllerProfile(client),
      queue: ReadarrControllerQueue(client),
      release: ReadarrControllerRelease(client),
      rootFolder: ReadarrControllerRootFolder(client),
      system: ReadarrControllerSystem(client),
      tag: ReadarrControllerTag(client),
      wanted: ReadarrControllerWanted(client),
    );
  }

  final Dio httpClient;
  final ReadarrControllerAuthor author;
  final ReadarrControllerBook book;
  final ReadarrControllerBookLookup bookLookup;
  final ReadarrControllerCommand command;
  final ReadarrControllerHistory history;
  final ReadarrControllerMetadataProfile metadataProfile;
  final ReadarrControllerProfile profile;
  final ReadarrControllerQueue queue;
  final ReadarrControllerRelease release;
  final ReadarrControllerRootFolder rootFolder;
  final ReadarrControllerSystem system;
  final ReadarrControllerTag tag;
  final ReadarrControllerWanted wanted;
}
