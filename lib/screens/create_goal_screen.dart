import 'package:flutter/material.dart';

/// Screen for creating a new saving goal
class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({Key? key}) : super(key: key);

  static const routeName = '/create-goal';

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _goalNameController;
  late TextEditingController _targetAmountController;

  @override
  void initState() {
    super.initState();
    _goalNameController = TextEditingController();
    _targetAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Target Nabung'),
        backgroundColor: const Color(0xFF10b981),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Goal name field
              TextFormField(
                controller: _goalNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Target',
                  hintText: 'Contoh: Liburan ke Bali',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nama target tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Target amount field
              TextFormField(
                controller: _targetAmountController,
                decoration: InputDecoration(
                  labelText: 'Target Amount (Rp)',
                  hintText: '5000000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Amount tidak boleh kosong';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Create button
              ElevatedButton(
                onPressed: _createGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10b981),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Buat Target'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createGoal() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save goal to database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal created successfully')),
      );
      Navigator.of(context).pop();
    }
  }
}
