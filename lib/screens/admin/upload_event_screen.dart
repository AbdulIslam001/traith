import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/color.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();

  XFile? _images;
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  DateTime? _selectedDate;

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormatter.format(picked);
      });
    }
  }

  Future<void> _pickImages() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked?.path !=null) {
        setState(() {
          _images = picked;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image picking failed: $e')));
    }
  }

  Future<String> _uploadImageToStorage(XFile imageFile) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
    String path='uploads/$fileName';
    final file=File(imageFile.path);
    Reference ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    print('uploadTask $uploadTask');
    TaskSnapshot snapshot = await uploadTask;
    print('snapshot $snapshot');
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _uploadPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images?.path == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select event poster')));
      return;
    }

    setState(() => _isUploading = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading... Please wait.')));

    try {
      /*List<String> imageUrls = [];
      for (var image in _images!) {
        String url = await _uploadImageToStorage(image);
        imageUrls.add(url);
      }*/
      //String url = await _uploadImageToStorage(_images!);

      //print('Url $url');
      Map<String , dynamic> body={
        'title': _titleController.text.trim(),
        'time': _dateController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'contact': _contactController.text.trim(),
        //'imageUrl': url,
        'timestamp': FieldValue.serverTimestamp(),
      };


      dynamic response=await FirebaseFirestore.instance.collection('events').add(body);

      print('response $response');

      setState(() => _isUploading = false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event uploaded successfully!')));
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Event', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: AppColor.whiteColor,
        elevation: 1,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter title' : null,
                ),
                SizedBox(height: 12.h),

                // Date Picker
                buildDatePickerField(),
                SizedBox(height: 12.h),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter location' : null,
                ),
                SizedBox(height: 12.h),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter description' : null,
                ),
                SizedBox(height: 12.h),

                // Contact Number
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter contact number' : null,
                ),
                SizedBox(height: 12.h),

                // Image Picker
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: Icon(Icons.photo_library, size: 20.sp, color: Colors.black),
                  label: Text('Select Images', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.whiteColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                ),
                SizedBox(height: 12.h),

                // Selected Image Preview
                if ((_images?.path != null))
                  SizedBox(
                    height: 100.h,
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.file(
                          File(_images!.path),
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),

                _isUploading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: (){
                      _uploadPost();
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Upload Event',
                      style: TextStyle(fontSize: 18.sp, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePickerField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date',
        suffixIcon: Icon(Icons.calendar_today, size: 22.sp, color: Colors.green.shade700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      onTap: () => _pickDate(context),
      validator: (val) => val == null || val.isEmpty ? 'Please select date' : null,
    );
  }
}