import 'package:supabase_flutter/supabase_flutter.dart';

class NewsService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Initialize Supabase (call this in main.dart before runApp)
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  /// Get real-time news stream
  /// Returns a stream that updates instantly when database changes
  static Stream<List<Map<String, dynamic>>> getNewsStream() {
    return _client
        .from('news')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.cast<Map<String, dynamic>>());
  }

  /// Optional: Fetch news once (non-streaming)
  static Future<List<Map<String, dynamic>>> fetchNews() async {
    final response = await _client
        .from('news')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).cast<Map<String, dynamic>>();
  }
}
