import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_sidebar.dart';
import '../screens/analytics_screen.dart';
import '../screens/users_screen.dart';
import '../screens/surveys_screen.dart';
import '../screens/cashouts_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedSection = 'analytics';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().initializeDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DashboardSidebar(
            selectedSection: _selectedSection,
            onSectionChanged: (section) {
              setState(() {
                _selectedSection = section;
              });
            },
          ),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedSection) {
      case 'analytics':
        return const AnalyticsScreen();
      case 'users':
        return const UsersScreen();
      case 'surveys':
        return const SurveysScreen();
      case 'cashouts':
        return const CashoutsScreen();
      default:
        return const AnalyticsScreen();
    }
  }
}
