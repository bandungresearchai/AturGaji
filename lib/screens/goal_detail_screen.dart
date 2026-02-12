import 'package:flutter/material.dart';

/// Screen showing details of a single saving goal
///
/// Displays:
/// - Goal information
/// - Progress visualization
/// - Transaction history
/// - Add savings button
class GoalDetailScreen extends StatefulWidget {
  final int goalId;

  const GoalDetailScreen({
    Key? key,
    required this.goalId,
  }) : super(key: key);

  static const routeName = '/goal-detail';

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Target'),
        backgroundColor: const Color(0xFF10b981),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Goal header with progress
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF10b981),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Liburan ke Bali',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rp 2.500.000 / Rp 5.000.000',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '50%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Add savings button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _addSavings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10b981),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Tambah Tabungan'),
              ),
            ),
            const SizedBox(height: 24),

            // Transaction history
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // TODO: Display transaction list
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('Belum ada transaksi'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSavings() {
    // TODO: Show add savings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add savings feature coming soon')),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Target'),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Hapus Target'),
            ),
          ],
        ),
      ),
    );
  }
}
