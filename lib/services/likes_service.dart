import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;


  static String _getLikeDocId(String postId, String userId) {
    return '${postId}_$userId';
  }

  /// Check if current user has already liked this post
  static Future<bool> hasUserLikedPost(String postId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final likeDocId = _getLikeDocId(postId, currentUser.uid);
      final doc = await _firestore.collection('tbl_likes').doc(likeDocId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking like status: $e');
      return false;
    }
  }

  /// Like a post
  static Future<bool> likePost(String postId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('User not authenticated');
        return false;
      }

      final likeDocId = _getLikeDocId(postId, currentUser.uid);

      // Add like to tbl_likes
      await _firestore.collection('tbl_likes').doc(likeDocId).set({
        'post_id': postId,
        'user_id': currentUser.uid,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Increment like count in post
      await _firestore.collection('tbl_posts').doc(postId).update({
        'nooflikeAT': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error liking post: $e');
      return false;
    }
  }

  /// Unlike a post
  static Future<bool> unlikePost(String postId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('User not authenticated');
        return false;
      }

      final likeDocId = _getLikeDocId(postId, currentUser.uid);

      // Remove like from tbl_likes
      await _firestore.collection('tbl_likes').doc(likeDocId).delete();

      // Decrement like count in post
      await _firestore.collection('tbl_posts').doc(postId).update({
        'nooflikeAT': FieldValue.increment(-1),
      });

      return true;
    } catch (e) {
      print('Error unliking post: $e');
      return false;
    }
  }

  /// Toggle like (like or unlike)
  static Future<bool> toggleLike(String postId, bool isCurrentlyLiked) async {
    if (isCurrentlyLiked) {
      return unlikePost(postId);
    } else {
      return likePost(postId);
    }
  }
}
