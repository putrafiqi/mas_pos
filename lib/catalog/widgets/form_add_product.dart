import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mas_pos/catalog/catalog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({super.key});

  @override
  State<FormAddProduct> createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  final formAddProductKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  String? category;
  File? pictureFile;

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = TextTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Form(
        key: formAddProductKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Produk'),
              const Gap(24),
              FormField<XFile>(
                validator: (value) {
                  if (value == null) {
                    return 'Gambar produk wajib diisi';
                  }

                  final File imageFile = File(value.path);
                  final int fileSizeInBytes = imageFile.lengthSync();
                  final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
                  if (fileSizeInMB > 5) {
                    return 'Ukuran file maks 5 MB. (${fileSizeInMB.toStringAsFixed(2)} MB)';
                  }

                  final String fileExtension =
                      p.extension(imageFile.path).toLowerCase();
                  if (fileExtension != '.jpg' &&
                      fileExtension != '.jpeg' &&
                      fileExtension != '.png') {
                    return 'Format file harus JPG, JPEG atau PNG.';
                  }

                  return null;
                },
                builder: (field) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          image:
                              pictureFile != null
                                  ? DecorationImage(
                                    image: FileImage(pictureFile!),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                          border: Border.all(
                            color:
                                field.hasError
                                    ? Colors.red.shade800
                                    : Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final imagePicker = ImagePicker();
                            final image = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setState(() {
                                pictureFile = File(image.path);
                              });
                              field.didChange(image);
                            }
                          },
                          child:
                              pictureFile == null
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Pilih file untuk diunggah'),
                                      Text(
                                        'Format yang didukung: JPG , JPEG & PNG Gunakan file Maximum 5Mb',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                  : null,
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            field.errorText!,
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const Gap(16),

              Text('Nama Produk'),
              const Gap(8),
              TextFormField(
                controller: nameController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nama produk wajid diisi'
                            : null,
                decoration: InputDecoration(hintText: 'Nama produk'),
                textInputAction: TextInputAction.next,
              ),
              const Gap(8),

              Text('Harga Produk'),
              const Gap(8),
              TextFormField(
                controller: priceController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Harga produk wajib di isi'
                            : null,
                decoration: InputDecoration(hintText: 'Harga Produk'),
                keyboardType: TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
              ),
              const Gap(16),

              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    isExpanded: true,

                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Kategori produk wajib diisi'
                                : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Pilih Kategori Produk',
                    ),
                    items:
                        state.categories
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e.id,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                  );
                },
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
                        if (formAddProductKey.currentState!.validate()) {
                          context.read<ProductBloc>().add(
                            AddProduct(
                              nameController.text,
                              category!,
                              double.parse(priceController.text),
                              pictureFile!,
                            ),
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
