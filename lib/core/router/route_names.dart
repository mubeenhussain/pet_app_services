class RouteNames {
  RouteNames._();

  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const otp = '/auth/otp';
  static const forgotPassword = '/auth/forgot-password';
  static const setPassword = '/auth/set-password';

  // Main
  static const home = '/home';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const buyPet = '/buy-pet';
  static const pets = '/pets';
  static const addPet = '/pets/add';
  static const editPet = '/pets/:id/edit';
  static const orders = '/orders';

  // Chat
  static const messages = '/chat';
  static const chatThread = '/chat/:id';
  static String chatThreadPath(String id) => '/chat/$id';

  // Rides
  static const rideRequest = '/rides/request';
  static const rideReview = '/rides/review';
  static const ridePayment = '/rides/payment';
  static const rideSearching = '/rides/searching';
  static const rideWaitDriver = '/rides/wait-driver';
  static const rideStatus = '/rides/status/:id';
  static const rideDeliveryConfirm = '/rides/delivery-confirm';

  // Checkout
  static const checkout = '/checkout';
  static const paymentSuccess = '/checkout/success';
  static const paymentFailure = '/checkout/failure';

  // Verification
  static const accountType = '/verification/account-type';
  static const documentUpload = '/verification/documents';
  static const verificationStatus = '/verification/status';

  // Admin (Phase 1 subset)
  static const adminDashboard = '/admin';
  static const adminPendingDrivers = '/admin/pending-drivers';
}
