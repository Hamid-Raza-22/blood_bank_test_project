/// App-wide string constants
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Blood Bank';
  static const String appVersion = '1.0.0';

  // Auth
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String verifyOtp = 'Verify OTP';
  static const String googleSignIn = 'Sign in with Google';

  // Home
  static const String home = 'Home';
  static const String findDonors = 'Find Donors';
  static const String requestBlood = 'Request Blood';
  static const String bloodInstructions = 'Blood Instructions';

  // Donors
  static const String donors = 'Donors';
  static const String becomeDonor = 'Become a Donor';
  static const String availableDonors = 'Available Donors';

  // Chat
  static const String chats = 'Chats';
  static const String messages = 'Messages';
  static const String typeMessage = 'Type a message...';

  // Notifications
  static const String notifications = 'Notifications';
  static const String noNotifications = 'No notifications yet';
  static const String markAllRead = 'Mark all read';

  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String settings = 'Settings';

  // Public Needs
  static const String publicNeeds = 'Blood Requests';
  static const String postRequest = 'Post Blood Request';
  static const String acceptRequest = 'Accept Request';

  // Blood Types
  static const List<String> bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  // Error Messages
  static const String errorGeneric = 'Something went wrong';
  static const String errorNetwork = 'No internet connection';
  static const String errorAuth = 'Authentication failed';
  static const String errorInvalidEmail = 'Invalid email address';
  static const String errorWeakPassword = 'Password is too weak';

  // Success Messages
  static const String successLogin = 'Logged in successfully';
  static const String successSignup = 'Account created successfully';
  static const String successLogout = 'Logged out successfully';
  static const String successRequestSent = 'Request sent successfully';
}
