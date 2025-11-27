// TODO: PASTE YOUR SUPABASE URL AND KEY HERE
// Get these from: https://supabase.com/dashboard/project/YOUR_PROJECT/settings/api
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Initialize Supabase (call this in main.dart before runApp)
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    // Validate that user has replaced placeholder values
    if (url.contains('https://gnlkgstnulfenqxvrsur.supabase.co') || anonKey.contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdubGtnc3RudWxmZW5xeHZyc3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyMjg4NjYsImV4cCI6MjA3OTgwNDg2Nn0.aOqkffRPxI4GPM79ravi79gm8ecOG9XXjWCnao59RG0')) {
      print('❌ ERROR: You must update the Supabase credentials in main.dart');
      print('📝 Get your credentials from: https://supabase.com/dashboard');
      throw Exception('Supabase credentials not configured. Check main.dart');
    }
    
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
