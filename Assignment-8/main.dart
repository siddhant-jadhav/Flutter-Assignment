import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// DATA MODEL: Post
// ============================================================================
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Factory constructor to deserialize JSON received from REST API or local cache.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled Post',
      body: json['body'] as String? ?? '',
    );
  }

  /// Serialize Post instance to JSON map for local cache persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}

// ============================================================================
// DATA WRAPPER: FetchResult
// Encapsulates data payload along with origin metadata (Live vs Cache).
// ============================================================================
class FetchResult {
  final List<Post> posts;
  final bool isFromCache;
  final DateTime timestamp;
  final String message;

  const FetchResult({
    required this.posts,
    required this.isFromCache,
    required this.timestamp,
    required this.message,
  });
}

// ============================================================================
// SERVICE LAYER: PostRepository
// Handles REST API calls, timeout handling, error recovery, and SharedPreferences.
// ============================================================================
class PostRepository {
  static const String _apiEndpoint = 'https://jsonplaceholder.typicode.com/posts';
  static const String _cacheKeyPosts = 'cached_jsonplaceholder_posts_v1';
  static const String _cacheKeyTimestamp = 'cached_jsonplaceholder_timestamp_v1';

  final http.Client _client;

  PostRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches posts from REST API or falls back to SharedPreferences cache.
  /// [forceRefresh] bypasses any cached data check.
  /// [simulateOffline] forces a network failure to test offline cache fallback.
  Future<FetchResult> fetchPosts({
    bool forceRefresh = false,
    bool simulateOffline = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. If not forcing refresh, check if valid cache exists and offline mode requested
    if (simulateOffline) {
      final cachedResult = _loadFromCache(prefs);
      if (cachedResult != null) {
        return FetchResult(
          posts: cachedResult.posts,
          isFromCache: true,
          timestamp: cachedResult.timestamp,
          message: 'Offline Mode: Displaying data from local SharedPreferences cache.',
        );
      }
      throw Exception('Simulated offline mode enabled and no cached data is available.');
    }

    try {
      // 2. Attempt live HTTP GET request with a 10-second timeout
      final uri = Uri.parse(_apiEndpoint);
      final response = await _client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(response.body) as List<dynamic>;
        final posts = decodedList
            .map((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();

        // 3. Cache the raw JSON payload and timestamp into SharedPreferences
        final now = DateTime.now();
        await prefs.setString(_cacheKeyPosts, response.body);
        await prefs.setString(_cacheKeyTimestamp, now.toIso8601String());

        return FetchResult(
          posts: posts,
          isFromCache: false,
          timestamp: now,
          message: 'Live data successfully retrieved from JSONPlaceholder API.',
        );
      } else {
        throw Exception('Server returned HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (networkError) {
      // 4. Resilience Fallback: Attempt loading from SharedPreferences cache
      final cachedResult = _loadFromCache(prefs);
      if (cachedResult != null) {
        return FetchResult(
          posts: cachedResult.posts,
          isFromCache: true,
          timestamp: cachedResult.timestamp,
          message: 'Network issue ($networkError). Recovered data from local cache.',
        );
      }
      // Re-throw if no local cache exists
      rethrow;
    }
  }

  /// Helper to decode cached JSON from SharedPreferences.
  FetchResult? _loadFromCache(SharedPreferences prefs) {
    final cachedString = prefs.getString(_cacheKeyPosts);
    final cachedTimeStr = prefs.getString(_cacheKeyTimestamp);

    if (cachedString != null && cachedString.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedString) as List<dynamic>;
        final posts = decoded
            .map((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();
        final timestamp = cachedTimeStr != null
            ? DateTime.tryParse(cachedTimeStr) ?? DateTime.now()
            : DateTime.now();

        return FetchResult(
          posts: posts,
          isFromCache: true,
          timestamp: timestamp,
          message: 'Loaded from local storage.',
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Clears the stored posts and timestamp from SharedPreferences.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKeyPosts);
    await prefs.remove(_cacheKeyTimestamp);
  }

  /// Checks whether a local cache currently exists.
  Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString(_cacheKeyPosts);
    return cachedString != null && cachedString.isNotEmpty;
  }
}

// ============================================================================
// MAIN APPLICATION ROOT
// ============================================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterWithRestApp());
}

class FlutterWithRestApp extends StatelessWidget {
  const FlutterWithRestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API & Cache Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9488), // Teal 600
          primary: const Color(0xFF0D9488),
          secondary: const Color(0xFFF59E0B), // Amber 500
          surface: const Color(0xFFF8FAFC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Slate 100
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Color(0xFF0F766E), // Teal 700
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          color: Colors.white,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const RestApiHomeScreen(),
    );
  }
}

// ============================================================================
// HOME SCREEN: State & FutureBuilder Controller
// ============================================================================
class RestApiHomeScreen extends StatefulWidget {
  const RestApiHomeScreen({super.key});

  @override
  State<RestApiHomeScreen> createState() => _RestApiHomeScreenState();
}

class _RestApiHomeScreenState extends State<RestApiHomeScreen> {
  final PostRepository _repository = PostRepository();

  /// Cached Future to prevent infinite rebuild triggers in FutureBuilder
  late Future<FetchResult> _postsFuture;

  // Search & Filter State
  final TextEditingController _searchController = TextEditingController();
  int? _selectedUserId;
  String _searchQuery = '';
  bool _simulateOffline = false;

  @override
  void initState() {
    super.initState();
    // Initialize Future once in initState as required by best practices
    _postsFuture = _loadPosts(forceRefresh: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Triggers a fetch and assigns the new Future to refresh the FutureBuilder
  Future<FetchResult> _loadPosts({bool forceRefresh = false}) {
    return _repository.fetchPosts(
      forceRefresh: forceRefresh,
      simulateOffline: _simulateOffline,
    );
  }

  void _triggerRefresh({bool forceRefresh = true}) {
    setState(() {
      _postsFuture = _loadPosts(forceRefresh: forceRefresh);
    });
  }

  Future<void> _handleClearCache() async {
    await _repository.clearCache();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('SharedPreferences cache cleared successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    _triggerRefresh(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.cloud_sync_rounded, size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'REST API & Cache',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Simulate Offline Toggle Action
          IconButton(
            tooltip: _simulateOffline ? 'Offline Mode Active' : 'Online Mode Active',
            icon: Icon(
              _simulateOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
              color: _simulateOffline ? const Color(0xFFFBBF24) : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _simulateOffline = !_simulateOffline;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _simulateOffline
                        ? 'Simulated Offline Mode enabled. Fetches will use cache fallback.'
                        : 'Online Mode restored. Fetches will contact live API.',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _triggerRefresh(forceRefresh: false);
            },
          ),
          // Clear Cache Action
          IconButton(
            tooltip: 'Clear SharedPreferences Cache',
            icon: const Icon(Icons.cleaning_services_rounded),
            onPressed: _handleClearCache,
          ),
          // Force Refresh Action
          IconButton(
            tooltip: 'Reload / Refresh Data',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _triggerRefresh(forceRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline Simulation Alert Banner (when active)
          if (_simulateOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFFEF3C7), // Amber 100
              child: Row(
                children: [
                  const Icon(Icons.wifi_off_rounded, color: Color(0xFFD97706), size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Simulate Offline Active: Testing cache-first resilience.',
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _simulateOffline = false);
                      _triggerRefresh(forceRefresh: true);
                    },
                    child: const Text('Go Online'),
                  ),
                ],
              ),
            ),

          // Search and Filter Bar
          _buildSearchAndFilterHeader(),

          // Asynchronous FutureBuilder Area
          Expanded(
            child: FutureBuilder<FetchResult>(
              future: _postsFuture,
              builder: (context, snapshot) {
                // 1. ConnectionState: Waiting / Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                // 2. Error State: Network or Cache Failure
                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                // 3. Success State with Data
                if (snapshot.hasData) {
                  final result = snapshot.data!;
                  return _buildDataView(result);
                }

                // Default empty fallback
                return _buildEmptyState('No data received from service.');
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // SEARCH & FILTER HEADER
  // ============================================================================
  Widget _buildSearchAndFilterHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input Field
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim().toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search posts by title or keyword...',
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D9488)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // User Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Authors'),
                  selected: _selectedUserId == null,
                  onSelected: (_) {
                    setState(() => _selectedUserId = null);
                  },
                  selectedColor: const Color(0xFFCCFBF1),
                  checkmarkColor: const Color(0xFF0F766E),
                  labelStyle: TextStyle(
                    color: _selectedUserId == null ? const Color(0xFF0F766E) : Colors.black87,
                    fontWeight: _selectedUserId == null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                ...List.generate(6, (index) {
                  final userId = index + 1;
                  final isSelected = _selectedUserId == userId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      avatar: CircleAvatar(
                        radius: 10,
                        backgroundColor: isSelected ? const Color(0xFF0F766E) : Colors.grey[300],
                        child: Text(
                          '$userId',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      label: Text('User $userId'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedUserId = selected ? userId : null;
                        });
                      },
                      selectedColor: const Color(0xFFCCFBF1),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF0F766E) : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 1. ASYNC LOADING STATE (FutureBuilder Waiting)
  // ============================================================================
  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3.5,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fetching REST API Data...',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connecting to JSONPlaceholder & verifying SharedPreferences cache',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 2. ERROR STATE (FutureBuilder snapshot.hasError)
  // ============================================================================
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2), // Red 100
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 54,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Unable to Load Posts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _triggerRefresh(forceRefresh: true),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_simulateOffline) ...[
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _simulateOffline = false);
                      _triggerRefresh(forceRefresh: true);
                    },
                    icon: const Icon(Icons.wifi_rounded),
                    label: const Text('Disable Offline'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 3. SUCCESS / DATA VIEW (FutureBuilder snapshot.hasData)
  // ============================================================================
  Widget _buildDataView(FetchResult result) {
    // Filter posts based on user search query and selected author
    final filteredPosts = result.posts.where((post) {
      final matchesSearch = _searchQuery.isEmpty ||
          post.title.toLowerCase().contains(_searchQuery) ||
          post.body.toLowerCase().contains(_searchQuery);
      final matchesUser = _selectedUserId == null || post.userId == _selectedUserId;
      return matchesSearch && matchesUser;
    }).toList();

    return RefreshIndicator(
      color: const Color(0xFF0D9488),
      onRefresh: () async {
        _triggerRefresh(forceRefresh: true);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Cache & Origin Metadata Status Banner
          _buildCacheOriginBanner(result, filteredPosts.length),

          if (filteredPosts.isEmpty)
            _buildEmptyState(
              _searchQuery.isNotEmpty || _selectedUserId != null
                  ? 'No posts matched your current filters.'
                  : 'No posts available to display.',
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return _buildPostCard(post, result.isFromCache);
              },
            ),
        ],
      ),
    );
  }

  // ============================================================================
  // ORIGIN STATUS BANNER (Live API vs SharedPreferences Cache)
  // ============================================================================
  Widget _buildCacheOriginBanner(FetchResult result, int filteredCount) {
    final isCache = result.isFromCache;
    final timeStr =
        '${result.timestamp.hour.toString().padLeft(2, '0')}:${result.timestamp.minute.toString().padLeft(2, '0')}:${result.timestamp.second.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCache ? const Color(0xFFFFFBEB) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCache ? const Color(0xFFFDE68A) : const Color(0xFFBBF7D0),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCache ? const Color(0xFFF59E0B) : const Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCache ? Icons.save_rounded : Icons.public_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isCache ? 'CACHED DATA' : 'LIVE API DATA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isCache ? const Color(0xFFB45309) : const Color(0xFF15803D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isCache
                            ? const Color(0xFFFEF3C7)
                            : const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Synced at $timeStr',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isCache ? const Color(0xFF92400E) : const Color(0xFF166534),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  isCache
                      ? 'Loaded via SharedPreferences offline store ($filteredCount of ${result.posts.length} posts)'
                      : 'Retrieved directly via HTTP GET JSONPlaceholder ($filteredCount posts)',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCache ? const Color(0xFF78350F) : const Color(0xFF14532D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // POST ITEM CARD
  // ============================================================================
  Widget _buildPostCard(Post post, bool isCache) {
    // Generate harmonious author avatar colors based on userId
    final colors = [
      const Color(0xFF0D9488),
      const Color(0xFF4F46E5),
      const Color(0xFF7C3AED),
      const Color(0xFFDB2777),
      const Color(0xFFEA580C),
      const Color(0xFF0284C7),
      const Color(0xFF16A34A),
    ];
    final authorColor = colors[(post.userId - 1) % colors.length];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showPostDetailsModal(post, isCache),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Author badge & Post ID
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: authorColor.withValues(alpha: 0.15),
                    child: Text(
                      'U${post.userId}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: authorColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Author User #${post.userId}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      '#${post.id}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Post Title
              Text(
                post.title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.2,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Post Body Snippet
              Text(
                post.body,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  height: 1.45,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer: Read More & Quick Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tap to view full article',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: authorColor,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 18, color: authorColor),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // POST DETAILS MODAL BOTTOM SHEET
  // ============================================================================
  void _showPostDetailsModal(Post post, bool isCache) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom sheet drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Modal Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Post ID: ${post.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCache ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCache ? 'Storage: SharedPreferences' : 'Storage: Fresh Network',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isCache ? const Color(0xFF92400E) : const Color(0xFF166534),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Full Title
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),

              // Full Body
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  post.body,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF334155),
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================================
  // EMPTY STATE
  // ============================================================================
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
