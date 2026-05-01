import 'package:flutter/material.dart';
import 'package:example/models/student.dart';

Future<Student?> showStudentFormDialog(
  BuildContext context, {
  Student? existing,
}) {
  final isEdit = existing != null;

  final nameCtrl = TextEditingController(text: existing?.studentname ?? '');
  final nameKhCtrl = TextEditingController(text: existing?.studentnamekh ?? '');
  final genderCtrl = TextEditingController(text: existing?.gender ?? '');
  final classIdCtrl = TextEditingController(
    text: existing?.classid?.toString() ?? '',
  );

  final formKey = GlobalKey<FormState>();

  return showDialog<Student>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isEdit ? 'Edit Student' : 'Add Student'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// English Name
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Student Name (EN)',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              /// Khmer Name
              TextFormField(
                controller: nameKhCtrl,
                decoration: const InputDecoration(
                  labelText: 'Student Name (KH)',
                ),
              ),
              const SizedBox(height: 12),

              /// Gender
              TextFormField(
                controller: genderCtrl,
                decoration: const InputDecoration(labelText: 'Gender (M/F)'),
              ),
              const SizedBox(height: 12),

              /// Class ID
              TextFormField(
                controller: classIdCtrl,
                decoration: const InputDecoration(labelText: 'Class ID'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            final result = Student(
              studentid: existing?.studentid,
              studentname: nameCtrl.text.trim(),
              studentnamekh: nameKhCtrl.text.trim(),
              gender: genderCtrl.text.trim(),
              classid: int.parse(classIdCtrl.text),

              /// keep existing nested data
              studentClass: existing?.studentClass,
              attendances: existing?.attendances ?? [],
            );

            Navigator.pop(ctx, result);
          },
          child: Text(isEdit ? 'Update' : 'Create'),
        ),
      ],
    ),
  );
}
