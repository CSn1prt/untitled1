import 'package:shared_preferences/shared_preferences.dart';

class LoginStateManager {
  static const String _isLoggedInKey = 'isLoggedIn';

  // Private constructor to prevent direct instantiation
  LoginStateManager._();

  // Static instance for singleton pattern
  static final LoginStateManager _instance = LoginStateManager._();

  // Factory constructor to return the singleton instance
  factory LoginStateManager() => _instance;

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Method to set the login state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }
}

// Example Usage (in a Widget or other part of your app):
// Import the file where LoginStateManager is defined.
// import 'login_state_manager.dart';

// ... inside a Widget or other class ...

// Example of checking login state on app start:
// void checkLoginState() async {
//   final isLoggedIn = await LoginStateManager().isLoggedIn();
//   if (isLoggedIn) {
//     // Navigate to the main screen
//     print('User is logged in');
//   } else {
//     // Navigate to the login screen
//     print('User is not logged in');
//   }
// }

// Example of setting login state on successful login:
// void onLoginSuccess() async {
//   await LoginStateManager().setLoggedIn(true);
//   print('User logged in successfully');
// }

// Example of setting login state on logout:
// void onLogout() async {
//   await LoginStateManager().setLoggedIn(false);
//   print('User logged out');
// }