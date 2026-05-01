import 'package:example/models/student.dart';
import 'package:example/providers/student_provider.dart';
import 'package:example/widgets/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchAll();
    });
  }

  Future<void> _onAdd() async {
    final newStudent = await showStudentFormDialog(context);
    if (newStudent == null || !mounted) return;

    final ok = await context.read<StudentProvider>().create(newStudent);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Student created')));
    }
  }

  Future<void> _onEdit(Student s) async {
    final edited = await showStudentFormDialog(context, existing: s);
    if (edited == null || !mounted) return;
    final ok = await context.read<StudentProvider>().update(
      s.studentid!,
      edited,
    );

    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchAll();
    });

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Student updated')));
    }
  }

  Future<void> _onDelete(Student s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Delete "${s.studentname ?? 'this student'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final ok = await context.read<StudentProvider>().delete(s.studentid!);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Student deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<StudentProvider>().fetchAll(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
      ),
      body: Consumer<StudentProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError && provider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(provider.errorMessage ?? 'Error'),
                  ElevatedButton(
                    onPressed: provider.fetchAll,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.isEmpty) {
            return const Center(child: Text('No students yet. Tap + to add.'));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchAll,
            child: ListView.separated(
              reverse: true,
              itemCount: provider.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final s = provider.items[i];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      s.studentname != null
                          ? s.studentname![0].toUpperCase()
                          : '?',
                    ),
                  ),

                  title: Text(s.studentname ?? '(no name)'),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (s.studentnamekh != null) Text(s.studentnamekh!),

                      Text(
                        'Gender: ${s.gender ?? '-'}'
                        '${s.studentClass != null ? ' • ${s.studentClass!.classname}' : ''}',
                      ),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _onEdit(s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _onDelete(s),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
