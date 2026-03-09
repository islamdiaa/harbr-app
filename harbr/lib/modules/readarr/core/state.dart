import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/types/list_view_option.dart';

class ReadarrState extends HarbrModuleState {
  ReadarrState() {
    reset();
  }

  @override
  void reset() {
    _authors = null;
    _books = null;
    _missing = null;
    _rootFolders = null;
    _qualityProfiles = null;
    _metadataProfiles = null;
    _tags = null;

    resetProfile();
    if (_enabled) {
      fetchAllAuthors();
      fetchAllBooks();
      fetchMissing();
      fetchRootFolders();
      fetchQualityProfiles();
      fetchMetadataProfiles();
      fetchTags();
    }
    notifyListeners();
  }

  ///////////////
  /// PROFILE ///
  ///////////////

  /// API handler instance
  ReadarrAPI? _api;
  ReadarrAPI? get api => _api;

  /// Is the API enabled?
  bool _enabled = false;
  bool get enabled => _enabled;

  /// Readarr host
  String _host = '';
  String get host => _host;

  /// Readarr API key
  String _apiKey = '';
  String get apiKey => _apiKey;

  /// Headers to attach to all requests
  Map<dynamic, dynamic> _headers = {};
  Map<dynamic, dynamic> get headers => _headers;

  /// Reset the profile data, reinitializes API instance
  void resetProfile() {
    HarbrProfile _profile = HarbrProfile.current;
    // Copy profile into state
    _api = null;
    _enabled = _profile.readarrEnabled;
    _host = _profile.readarrHost;
    _apiKey = _profile.readarrKey;
    _headers = _profile.readarrHeaders;
    // Create the API instance if Readarr is enabled
    if (_enabled) {
      _api = ReadarrAPI(
        host: _host,
        apiKey: _apiKey,
        headers: Map<String, dynamic>.from(_headers),
      );
    }
  }

  /////////////////
  /// CATALOGUE ///
  /////////////////

  HarbrListViewOption _authorViewType =
      ReadarrDatabase.NAVIGATION_INDEX.read() == 0
          ? HarbrListViewOption.GRID_VIEW
          : HarbrListViewOption.BLOCK_VIEW;
  HarbrListViewOption get authorViewType => _authorViewType;
  set authorViewType(HarbrListViewOption authorViewType) {
    _authorViewType = authorViewType;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String searchQuery) {
    _searchQuery = searchQuery;
    notifyListeners();
  }

  ReadarrBooksSorting _sortType = ReadarrBooksSorting.ALPHABETICAL;
  ReadarrBooksSorting get sortType => _sortType;
  set sortType(ReadarrBooksSorting sortType) {
    _sortType = sortType;
    notifyListeners();
  }

  ReadarrBooksFilter _filterType = ReadarrBooksFilter.ALL;
  ReadarrBooksFilter get filterType => _filterType;
  set filterType(ReadarrBooksFilter filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;
  set sortAscending(bool sortAscending) {
    _sortAscending = sortAscending;
    notifyListeners();
  }

  ///////////////
  /// AUTHORS ///
  ///////////////

  Future<Map<int, ReadarrAuthor>>? _authors;
  Future<Map<int, ReadarrAuthor>>? get authors => _authors;
  void fetchAllAuthors() {
    if (_api != null) {
      _authors = _api!.author.getAll().then((authors) {
        return {
          for (ReadarrAuthor a in authors) a.id!: a,
        };
      });
    }
    notifyListeners();
  }

  Future<void> fetchAuthor(int authorId) async {
    if (_api != null) {
      ReadarrAuthor author = await _api!.author.get(authorId: authorId);
      (await _authors)![authorId] = author;
    }
    notifyListeners();
  }

  Future<void> setSingleAuthor(ReadarrAuthor author) async {
    (await _authors)![author.id!] = author;
    notifyListeners();
  }

  Future<void> removeSingleAuthor(int authorId) async {
    (await _authors)!.remove(authorId);
    notifyListeners();
  }

  /////////////
  /// BOOKS ///
  /////////////

  Future<List<ReadarrBook>>? _books;
  Future<List<ReadarrBook>>? get books => _books;
  void fetchAllBooks() {
    if (_api != null) _books = _api!.book.getAll();
    notifyListeners();
  }

  ///////////////
  /// MISSING ///
  ///////////////

  Future<ReadarrMissing>? _missing;
  Future<ReadarrMissing>? get missing => _missing;
  set missing(Future<ReadarrMissing>? missing) {
    _missing = missing;
    notifyListeners();
  }

  void fetchMissing() {
    if (_api != null)
      _missing = _api!.wanted.getMissing(
        pageSize: ReadarrDatabase.CONTENT_PAGE_SIZE.read(),
      );
    notifyListeners();
  }

  ////////////////
  /// PROFILES ///
  ////////////////

  Future<List<ReadarrQualityProfile>>? _qualityProfiles;
  Future<List<ReadarrQualityProfile>>? get qualityProfiles => _qualityProfiles;
  set qualityProfiles(Future<List<ReadarrQualityProfile>>? qualityProfiles) {
    _qualityProfiles = qualityProfiles;
    notifyListeners();
  }

  void fetchQualityProfiles() {
    if (_api != null) _qualityProfiles = _api!.profile.getQualityProfiles();
    notifyListeners();
  }

  Future<List<ReadarrMetadataProfile>>? _metadataProfiles;
  Future<List<ReadarrMetadataProfile>>? get metadataProfiles =>
      _metadataProfiles;
  set metadataProfiles(
      Future<List<ReadarrMetadataProfile>>? metadataProfiles) {
    _metadataProfiles = metadataProfiles;
    notifyListeners();
  }

  void fetchMetadataProfiles() {
    if (_api != null) _metadataProfiles = _api!.metadataProfile.getAll();
    notifyListeners();
  }

  ////////////////////
  /// ROOT FOLDERS ///
  ////////////////////

  Future<List<ReadarrRootFolder>>? _rootFolders;
  Future<List<ReadarrRootFolder>>? get rootFolders => _rootFolders;
  void fetchRootFolders() {
    if (_api != null) _rootFolders = _api!.rootFolder.getAll();
    notifyListeners();
  }

  ////////////
  /// TAGS ///
  ////////////

  Future<List<ReadarrTag>>? _tags;
  Future<List<ReadarrTag>>? get tags => _tags;
  set tags(Future<List<ReadarrTag>>? tags) {
    _tags = tags;
    notifyListeners();
  }

  void fetchTags() {
    if (_api != null) _tags = _api!.tag.getAll();
    notifyListeners();
  }

  //////////////
  /// IMAGES ///
  //////////////

  String _buildImageUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) return '';
    String base = _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;
    String path = relativeUrl.startsWith('/') ? relativeUrl : '/$relativeUrl';
    return '$base$path?apikey=$_apiKey';
  }

  String getAuthorPosterURL(ReadarrAuthor? author) {
    if (author?.images == null || author!.images!.isEmpty) {
      return author?.remotePoster ?? '';
    }
    for (var img in author.images!) {
      if (img.coverType == 'poster') {
        if (img.remoteUrl != null && img.remoteUrl!.isNotEmpty) {
          return img.remoteUrl!;
        }
        if (img.url != null && img.url!.isNotEmpty) {
          return _buildImageUrl(img.url);
        }
      }
    }
    return author.remotePoster ?? '';
  }

  String getBookCoverURL(ReadarrBook? book) {
    if (book?.images == null || book!.images!.isEmpty) return '';
    for (var img in book.images!) {
      if (img.coverType == 'cover') {
        if (img.remoteUrl != null && img.remoteUrl!.isNotEmpty) {
          return img.remoteUrl!;
        }
        if (img.url != null && img.url!.isNotEmpty) {
          return _buildImageUrl(img.url);
        }
      }
    }
    return '';
  }
}
