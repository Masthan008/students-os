import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

class BooksService {
  static final _supabase = Supabase.instance.client;
  
  // Get current user ID
  static String _getCurrentUserId() {
    final box = Hive.box('user_prefs');
    return box.get('user_id', defaultValue: 'guest');
  }
  
  // Get current user name
  static String _getCurrentUserName() {
    final box = Hive.box('user_prefs');
    return box.get('user_name', defaultValue: 'Student');
  }
  
  // Upload book to Supabase Storage
  static Future<String?> uploadBookFile(File file, String fileName) async {
    try {
      final userId = _getCurrentUserId();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath = 'books/$userId/$timestamp-$fileName';
      
      await _supabase.storage
          .from('shared-files')
          .upload(storagePath, file);
      
      final publicUrl = _supabase.storage
          .from('shared-files')
          .getPublicUrl(storagePath);
      
      debugPrint('✅ File uploaded: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('⚠️ File upload error: $e');
      return null;
    }
  }
  
  // Share book to community
  static Future<bool> shareBook({
    required String title,
    required String author,
    required String subject,
    String? link,
    String? fileUrl,
    String? fileName,
  }) async {
    try {
      final userId = _getCurrentUserId();
      final userName = _getCurrentUserName();
      
      await _supabase.from('shared_books').insert({
        'title': title,
        'author': author,
        'subject': subject,
        'link': link,
        'file_url': fileUrl,
        'file_name': fileName,
        'uploaded_by': userId,
        'uploader_name': userName,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      debugPrint('✅ Book shared: $title');
      return true;
    } catch (e) {
      debugPrint('⚠️ Share book error: $e');
      return false;
    }
  }
  
  // Get all shared books
  static Future<List<Map<String, dynamic>>> getSharedBooks({String? subject}) async {
    try {
      var query = _supabase
          .from('shared_books')
          .select()
          .order('created_at', ascending: false);
      
      if (subject != null && subject != 'All') {
        query = query.eq('subject', subject);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get shared books error: $e');
      return [];
    }
  }
  
  // Like a book
  static Future<bool> likeBook(int bookId) async {
    try {
      final userId = _getCurrentUserId();
      
      // Check if already liked
      final existing = await _supabase
          .from('book_likes')
          .select()
          .eq('book_id', bookId)
          .eq('user_id', userId)
          .maybeSingle();
      
      if (existing != null) {
        // Unlike
        await _supabase
            .from('book_likes')
            .delete()
            .eq('book_id', bookId)
            .eq('user_id', userId);
        
        // Decrement likes count
        await _supabase.rpc('decrement_book_likes', params: {'book_id': bookId});
        
        debugPrint('✅ Book unliked');
        return false;
      } else {
        // Like
        await _supabase.from('book_likes').insert({
          'book_id': bookId,
          'user_id': userId,
        });
        
        // Increment likes count
        await _supabase.rpc('increment_book_likes', params: {'book_id': bookId});
        
        debugPrint('✅ Book liked');
        return true;
      }
    } catch (e) {
      debugPrint('⚠️ Like book error: $e');
      return false;
    }
  }
  
  // Check if user liked a book
  static Future<bool> hasLikedBook(int bookId) async {
    try {
      final userId = _getCurrentUserId();
      
      final response = await _supabase
          .from('book_likes')
          .select()
          .eq('book_id', bookId)
          .eq('user_id', userId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      debugPrint('⚠️ Check like error: $e');
      return false;
    }
  }
  
  // Increment download count
  static Future<void> incrementDownloads(int bookId) async {
    try {
      await _supabase.rpc('increment_book_downloads', params: {'book_id': bookId});
      debugPrint('✅ Download count incremented');
    } catch (e) {
      debugPrint('⚠️ Increment downloads error: $e');
    }
  }
  
  // Delete book (only if uploaded by current user)
  static Future<bool> deleteBook(int bookId) async {
    try {
      final userId = _getCurrentUserId();
      
      await _supabase
          .from('shared_books')
          .delete()
          .eq('id', bookId)
          .eq('uploaded_by', userId);
      
      debugPrint('✅ Book deleted');
      return true;
    } catch (e) {
      debugPrint('⚠️ Delete book error: $e');
      return false;
    }
  }
  
  // Get books uploaded by current user
  static Future<List<Map<String, dynamic>>> getMyBooks() async {
    try {
      final userId = _getCurrentUserId();
      
      final response = await _supabase
          .from('shared_books')
          .select()
          .eq('uploaded_by', userId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get my books error: $e');
      return [];
    }
  }
  
  // Search books
  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    try {
      final response = await _supabase
          .from('shared_books')
          .select()
          .or('title.ilike.%$query%,author.ilike.%$query%,subject.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Search books error: $e');
      return [];
    }
  }
  
  // Get popular books (most liked)
  static Future<List<Map<String, dynamic>>> getPopularBooks({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('shared_books')
          .select()
          .order('likes', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get popular books error: $e');
      return [];
    }
  }
  
  // Get recent books
  static Future<List<Map<String, dynamic>>> getRecentBooks({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('shared_books')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get recent books error: $e');
      return [];
    }
  }
}

// Add these SQL functions to Supabase:
/*
CREATE OR REPLACE FUNCTION increment_book_likes(book_id BIGINT)
RETURNS VOID AS $$
BEGIN
  UPDATE shared_books
  SET likes = likes + 1
  WHERE id = book_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_book_likes(book_id BIGINT)
RETURNS VOID AS $$
BEGIN
  UPDATE shared_books
  SET likes = GREATEST(0, likes - 1)
  WHERE id = book_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION increment_book_downloads(book_id BIGINT)
RETURNS VOID AS $$
BEGIN
  UPDATE shared_books
  SET downloads = downloads + 1
  WHERE id = book_id;
END;
$$ LANGUAGE plpgsql;
*/
