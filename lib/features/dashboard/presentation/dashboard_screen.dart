import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screen_time/presentation/screen_time_permission_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              const ScreenTimePermissionCard(),
              const SizedBox(height: 16),
              _buildSummaryRow(),
              const SizedBox(height: 30),
              Text(
                'Today\'s Insights',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _buildDataCards(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'LifeOS',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundColor: Color(0xFF1E1E1E),
          child: Icon(Icons.settings, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMiniStatCard('Streak', '12 days', Icons.local_fire_department, const Color(0xFFFF4500)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMiniStatCard('Activity Score', '85%', Icons.health_and_safety, const Color(0xFF00FF66)),
        ),
      ],
    );
  }

  Widget _buildMiniStatCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDataCards(BuildContext context) {
    return Column(
      children: [
        _buildMainCard('Sleep Quality', '7h 24m', 'Optimal resting heart rate', Icons.bedtime, const Color(0xFF00F0FF)),
        const SizedBox(height: 16),
        _buildMainCard('Screen Time', '4h 12m', '-30m from yesterday', Icons.smartphone, const Color(0xFF9D00FF)),
        const SizedBox(height: 16),
        _buildMainCard('Movement', '8,432 steps', 'On track for daily goal', Icons.directions_walk, const Color(0xFF00FF66)),
      ],
    );
  }

  Widget _buildMainCard(String title, String mainValue, String subtitle, IconData icon, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(mainValue, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: iconColor, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
