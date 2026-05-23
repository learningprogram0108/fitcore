import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/training_log/presentation/training_log_page.dart';
import '../../features/program/presentation/program_page.dart';
import '../../features/program/presentation/exercise_detail_page.dart';
import '../../features/nutrition/presentation/nutrition_page.dart';
import '../../features/ai_coach/presentation/ai_coach_page.dart';
import '../../features/knowledge_base/presentation/knowledge_base_page.dart';

// ── 路由路徑常數 ──────────────────────────────────────────
abstract class AppRoutes {
  static const log            = '/log';
  static const program        = '/program';
  static const programExercise = '/program/exercise/:movementId';
  static const nutrition      = '/nutrition';
  static const aiCoach        = '/ai-coach';
  static const knowledge      = '/knowledge';
  static const knowledgeEx    = '/knowledge/:exerciseId';
}

// ── Riverpod Provider ─────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.log,
    routes: [
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.log,
            pageBuilder: (c, s) => const NoTransitionPage(child: TrainingLogPage()),
          ),
          GoRoute(
            path: AppRoutes.program,
            pageBuilder: (c, s) => const NoTransitionPage(child: ProgramPage()),
            routes: [
              GoRoute(
                path: 'exercise/:movementId',
                builder: (c, s) => ExerciseDetailPage(
                  movementId: s.pathParameters['movementId']!,
                  extra: s.extra is ExerciseExtra
                      ? s.extra as ExerciseExtra
                      : null,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.nutrition,
            pageBuilder: (c, s) => const NoTransitionPage(child: NutritionPage()),
          ),
          GoRoute(
            path: AppRoutes.aiCoach,
            pageBuilder: (c, s) => const NoTransitionPage(child: AiCoachPage()),
          ),
          GoRoute(
            path: AppRoutes.knowledge,
            pageBuilder: (c, s) => const NoTransitionPage(child: KnowledgeBasePage()),
            routes: [
              GoRoute(
                path: ':exerciseId',
                builder: (c, s) => KnowledgeBasePage(
                  initialExercise: s.pathParameters['exerciseId'],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// ── 主框架 Shell（底部導覽）──────────────────────────────
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => _MobileLayout(child: child);
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _bottomNav(context),
    );
  }
}

// ── 底部導覽（行動端）────────────────────────────────────
Widget _bottomNav(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
  return NavigationBar(
    selectedIndex: _navIndex(location),
    onDestinationSelected: (i) => _navigate(context, i),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.edit_note_outlined), selectedIcon: Icon(Icons.edit_note), label: '日誌'),
      NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: '課表'),
      NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), selectedIcon: Icon(Icons.local_fire_department), label: '營養'),
      NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'AI'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '知識庫'),
    ],
  );
}

int _navIndex(String location) {
  if (location.startsWith(AppRoutes.program))   return 1;
  if (location.startsWith(AppRoutes.nutrition)) return 2;
  if (location.startsWith(AppRoutes.aiCoach))   return 3;
  if (location.startsWith(AppRoutes.knowledge)) return 4;
  return 0; // log (default)
}

void _navigate(BuildContext context, int i) {
  const routes = [
    AppRoutes.log, AppRoutes.program, AppRoutes.nutrition,
    AppRoutes.aiCoach, AppRoutes.knowledge,
  ];
  context.go(routes[i]);
}
