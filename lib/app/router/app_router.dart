import 'package:go_router/go_router.dart';
import 'package:nesta/features/auth/screens/splash_screen.dart';
import 'package:nesta/features/auth/screens/welcome_screen.dart';
import 'package:nesta/features/auth/screens/login_screen.dart';
import 'package:nesta/features/auth/screens/register_screen.dart';
import 'package:nesta/features/auth/screens/email_confirmation_screen.dart';
import 'package:nesta/features/house/screens/house_selection_screen.dart';
import 'package:nesta/features/house/screens/create_house_screen.dart';
import 'package:nesta/features/house/screens/join_house_screen.dart';
import 'package:nesta/features/house/screens/house_invite_screen.dart';
import 'package:nesta/features/onboarding/screens/onboarding_screen.dart';
import 'package:nesta/features/dashboard/screens/main_layout.dart';
import 'package:nesta/features/chores/screens/room_list_screen.dart';
import 'package:nesta/features/chores/screens/room_detail_screen.dart';
import 'package:nesta/features/schedule/screens/schedule_screen.dart';
import 'package:nesta/features/activity/screens/activity_feed_screen.dart';
import 'package:nesta/features/task_detail/screens/task_detail_screen.dart';
import 'package:nesta/features/task_detail/screens/task_verification_screen.dart';
import 'package:nesta/features/finance/screens/financial_dashboard_screen.dart';
import 'package:nesta/features/finance/screens/fine_management_screen.dart';
import 'package:nesta/features/finance/screens/fine_settlement_screen.dart';
import 'package:nesta/features/finance/screens/rent_screen.dart';
import 'package:nesta/features/finance/screens/electricity_screen.dart';
import 'package:nesta/features/finance/screens/water_screen.dart';
import 'package:nesta/features/swap/screens/swap_request_screen.dart';
import 'package:nesta/features/swap/screens/swap_approval_screen.dart';
import 'package:nesta/features/analytics/screens/analytics_screen.dart';
import 'package:nesta/features/settings/screens/settings_screen.dart';
import 'package:nesta/features/settings/screens/profile_screen.dart';
import 'package:nesta/features/settings/screens/house_screen.dart';
import 'package:nesta/features/settings/screens/home_management_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/email-confirmation',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailConfirmationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/house/select',
      builder: (context, state) => const HouseSelectionScreen(),
    ),
    GoRoute(
      path: '/house/create',
      builder: (context, state) => const CreateHouseScreen(),
    ),
    GoRoute(
      path: '/house/join',
      builder: (context, state) => const JoinHouseScreen(),
    ),
    GoRoute(
      path: '/house/invite',
      builder: (context, state) => const HouseInviteScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainLayout(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: '/activity',
      builder: (context, state) => const ActivityFeedScreen(),
    ),
    GoRoute(
      path: '/rooms',
      builder: (context, state) => const RoomListScreen(),
    ),
    GoRoute(
      path: '/task/:taskId',
      builder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return TaskDetailScreen(taskId: taskId);
      },
      routes: [
        GoRoute(
          path: 'verification',
          builder: (context, state) {
            final taskId = state.pathParameters['taskId']!;
            return TaskVerificationScreen(taskId: taskId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/swap/request',
      builder: (context, state) => const SwapRequestScreen(),
    ),
    GoRoute(
      path: '/swap/approval',
      builder: (context, state) => const SwapApprovalScreen(),
    ),
    GoRoute(
      path: '/finance/fines',
      builder: (context, state) => const FineManagementScreen(),
    ),
    GoRoute(
      path: '/finance/rent',
      builder: (context, state) => const RentScreen(),
    ),
    GoRoute(
      path: '/finance/electricity',
      builder: (context, state) => const ElectricityScreen(),
    ),
    GoRoute(
      path: '/finance/water',
      builder: (context, state) => const WaterScreen(),
    ),
    GoRoute(
      path: '/fine/:fineId',
      builder: (context, state) {
        final fineId = state.pathParameters['fineId']!;
        return FineSettlementScreen(fineId: fineId);
      },
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings/house',
      builder: (context, state) => const HouseScreen(),
    ),
    GoRoute(
      path: '/settings/house/manage',
      builder: (context, state) => const HomeManagementScreen(),
    ),
    GoRoute(
      path: '/rooms/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return RoomDetailScreen(roomId: roomId);
      },
    ),
  ],
);
