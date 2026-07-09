import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/config/app_config.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:pet_app/features/admin/presentation/screens/pending_driver_requests_screen.dart';
import 'package:pet_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pet_app/features/auth/presentation/screens/login_screen.dart';
import 'package:pet_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:pet_app/features/auth/presentation/screens/register_screen.dart';
import 'package:pet_app/features/auth/presentation/screens/set_password_screen.dart';
import 'package:pet_app/features/chat/presentation/screens/chat_thread_screen.dart';
import 'package:pet_app/features/chat/presentation/screens/messages_list_screen.dart';
import 'package:pet_app/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:pet_app/features/checkout/presentation/screens/payment_failure_screen.dart';
import 'package:pet_app/features/checkout/presentation/screens/payment_success_screen.dart';
import 'package:pet_app/features/home/presentation/screens/home_screen.dart';
import 'package:pet_app/features/pets/presentation/screens/buy_pet_detail_screen.dart';
import 'package:pet_app/features/pets/presentation/screens/buy_pet_filters_screen.dart';
import 'package:pet_app/features/pets/presentation/screens/buy_pet_screen.dart';
import 'package:pet_app/features/pets/presentation/providers/buy_pet_demo_listings.dart';
import 'package:pet_app/features/pets/presentation/utils/buy_pet_filters.dart';
import 'package:pet_app/features/pets/presentation/screens/add_pet_screen.dart';
import 'package:pet_app/features/pets/presentation/screens/edit_pet_screen.dart';
import 'package:pet_app/features/pets/presentation/screens/pets_list_screen.dart';
import 'package:pet_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:pet_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:pet_app/features/profile/presentation/screens/service_history_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_delivery_confirm_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_payment_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_request_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_review_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_searching_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_status_screen.dart';
import 'package:pet_app/features/rides/presentation/screens/ride_wait_driver_screen.dart';
import 'package:pet_app/features/verification/presentation/screens/account_type_screen.dart';
import 'package:pet_app/features/verification/presentation/screens/document_upload_screen.dart';
import 'package:pet_app/features/verification/presentation/screens/verification_status_screen.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/providers/guest_mode_provider.dart';

class RouteGuards {
  RouteGuards._();

  static String? redirect(GoRouterState state, Ref ref) {
    final authState = ref.read(authStateProvider);
    final location = state.matchedLocation;
    final isAuthRoute = location.startsWith('/auth');
    final isAdminRoute = location.startsWith('/admin');
    final isGuestAllowed = location == RouteNames.login;

    return authState.when(
      data: (session) {
        final isLoggedIn = session.isAuthenticated;
        final isGuest = session.isGuest || ref.read(guestModeProvider);
        final isAdmin = session.user?.isAdmin ?? false;

        if (!isLoggedIn && !isGuest && !isAuthRoute && !isGuestAllowed) {
          return RouteNames.login;
        }

        if ((isLoggedIn || isGuest) && isAuthRoute) {
          return AppConfig.instance.isAdmin
              ? RouteNames.adminDashboard
              : RouteNames.home;
        }

        if (isAdminRoute && !isAdmin && AppConfig.instance.isAdmin) {
          return RouteNames.login;
        }

        if (isAdminRoute && !AppConfig.instance.isAdmin) {
          return RouteNames.home;
        }

        return null;
      },
      loading: () => null,
      error: (_, __) => isAuthRoute ? null : RouteNames.login,
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, __) => refresh.value++);
  ref.listen(guestModeProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: RouteNames.login,
    refreshListenable: refresh,
    redirect: (context, state) => RouteGuards.redirect(state, ref),
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (_, state) => OtpScreen(
          phone: state.uri.queryParameters['phone'] ?? '',
          flow: state.uri.queryParameters['flow'] ?? 'register',
        ),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.setPassword,
        builder: (_, __) => const SetPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.buyPet,
        builder: (_, __) => const BuyPetScreen(),
        routes: [
          GoRoute(
            path: 'filters',
            builder: (_, state) => BuyPetFiltersScreen(
              args: state.extra! as BuyPetFiltersArgs,
            ),
          ),
          GoRoute(
            path: ':id',
            builder: (_, state) {
              final listing =
                  buyPetListingById(state.pathParameters['id']!);
              if (listing == null) {
                return const Scaffold(
                  body: Center(child: Text('Listing not found')),
                );
              }
              return BuyPetDetailScreen(listing: listing);
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.pets,
        builder: (_, __) => const PetsListScreen(),
      ),
      GoRoute(
        path: RouteNames.addPet,
        builder: (_, __) => const AddPetScreen(),
      ),
      GoRoute(
        path: RouteNames.editPet,
        builder: (_, state) => EditPetScreen(
          petId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RouteNames.orders,
        builder: (_, __) => const ServiceHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.messages,
        builder: (_, __) => const MessagesListScreen(),
      ),
      GoRoute(
        path: RouteNames.chatThread,
        builder: (_, state) => ChatThreadScreen(
          conversationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RouteNames.rideRequest,
        builder: (_, __) => const RideRequestScreen(),
      ),
      GoRoute(
        path: RouteNames.rideReview,
        builder: (_, __) => const RideReviewScreen(),
      ),
      GoRoute(
        path: RouteNames.ridePayment,
        builder: (_, __) => const RidePaymentScreen(),
      ),
      GoRoute(
        path: RouteNames.rideSearching,
        builder: (_, __) => const RideSearchingScreen(),
      ),
      GoRoute(
        path: RouteNames.rideWaitDriver,
        builder: (_, __) => const RideWaitDriverScreen(),
      ),
      GoRoute(
        path: RouteNames.rideStatus,
        builder: (_, state) => RideStatusScreen(
          rideId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RouteNames.rideDeliveryConfirm,
        builder: (_, __) => const RideDeliveryConfirmScreen(),
      ),
      GoRoute(
        path: RouteNames.checkout,
        builder: (_, __) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RouteNames.paymentSuccess,
        builder: (_, __) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: RouteNames.paymentFailure,
        builder: (_, __) => const PaymentFailureScreen(),
      ),
      GoRoute(
        path: RouteNames.accountType,
        builder: (_, __) => const AccountTypeScreen(),
      ),
      GoRoute(
        path: RouteNames.documentUpload,
        builder: (_, __) => const DocumentUploadScreen(),
      ),
      GoRoute(
        path: RouteNames.verificationStatus,
        builder: (_, __) => const VerificationStatusScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.adminPendingDrivers,
        builder: (_, __) => const PendingDriverRequestsScreen(),
      ),
    ],
  );
});
