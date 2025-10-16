import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mas_pos/catalog/catalog.dart';

class FormAddCategory extends StatefulWidget {
  const FormAddCategory({super.key});

  @override
  State<FormAddCategory> createState() => _FormAddCategoryState();
}

class _FormAddCategoryState extends State<FormAddCategory> {
  final formAddCategory = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Form(
        key: formAddCategory,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Kategori'),
              const Gap(24),
              TextFormField(
                controller: nameController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nama kategori wajib di isi'
                            : null,
                decoration: InputDecoration(hintText: 'Nama kategori'),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        side: BorderSide(color: Colors.blue.shade800),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.blue.shade800,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Batal'),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (formAddCategory.currentState!.validate()) {
                          context.read<CategoryBloc>().add(
                            AddCategory(nameController.text),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Tambah'),
                    ),
                  ),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
