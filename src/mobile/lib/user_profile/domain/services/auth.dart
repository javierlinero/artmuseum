import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> getUserToken() async {
    return await currentUser?.getIdToken() ?? '';
  }

  Future<String?> getUserDisplayName() async {
    // Check if current user's display name is available
    String? displayName = _firebaseAuth.currentUser?.displayName;

    // If display name is available, return it
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    // If not, fetch from the server
    try {
      String? token = await _firebaseAuth.currentUser?.getIdToken();

      // Dio instance for network request
      Dio dio = Dio();

      // Endpoint URL
      String endpointUrl = 'http://puamdns.ddns.net/user_profile';

      // Prepare headers
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Make GET request
      Response response = await dio.get(
        endpointUrl,
        options: Options(headers: headers),
      );

      // Parse response
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        return responseData['displayName'];
      } else {
        // Handle non-200 responses
        debugPrint('Error: Unexpected server response');
        return null;
      }
    } catch (e) {
      // Handle network or Dio errors
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await signUpAndSendData(email, password, displayName);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signUpAndSendData(
      String email, String password, String displayName) async {
    try {
      // Get the token of the newly created user
      String? token = await _firebaseAuth.currentUser?.getIdToken();

      // Dio instance
      Dio dio = Dio();

      // Endpoint URL
      String endpointUrl = 'http://puamdns.ddns.net/create_user';

      // Prepare headers
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Prepare data
      Map<String, dynamic> data = {
        'email': email,
        'display_name': displayName,
      };

      // Make POST request
      Response response = await dio.post(
        endpointUrl,
        options: Options(headers: headers),
        data: data,
      );

      // Handle response
      print('Server response: ${response.data}');
    } catch (e) {
      print('Error: $e');
    }
  }
}
