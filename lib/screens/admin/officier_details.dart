import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traith/utils/color.dart';

class OfficiersDetails extends StatefulWidget {
  final bool isAdmin;
  const OfficiersDetails({super.key, required this.isAdmin});

  @override
  State<OfficiersDetails> createState() => _OfficiersDetailsState();
}

class _OfficiersDetailsState extends State<OfficiersDetails> {
  String searchText = '';
  String selectedStatus = 'Serving';
  String listOf = 'Serving';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              TextFormField(
                cursorColor: AppColor.greenColor,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.greenColor,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
              ),
              SizedBox(height: 10.h),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Filter by Status',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade400),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  icon: const Icon(Icons.arrow_drop_down),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  items: ['Serving', 'Retired'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatus = newValue!;
                    });
                  },
                ),
              ),


              //SizedBox(height: 20.h),


              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('officers_detail')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No officer data found.');
                  }

                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    print(doc);
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name']?.toLowerCase() ?? '';
                    final rank = data['rank']?.toLowerCase() ?? '';
                    final status = data['status']?.toLowerCase() ?? '';

                    return (name.contains(searchText) || rank.contains(searchText)) &&
                        status == selectedStatus.toLowerCase();
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Text('No officers match the search and filter criteria.');
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final data = filteredDocs[index].data() as Map<String, dynamic>;
                      return OfficerCard(data: data);
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),

      // FAB for admin only
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        backgroundColor: AppColor.greenColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  title: const Text("Upload CSV File"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Serving'),
                          leading: Radio<String>(
                            value: 'Serving',
                            groupValue: listOf,
                            onChanged: (value) {
                              setDialogState(() {
                                listOf = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Retired'),
                          leading: Radio<String>(
                            value: 'Retired',
                            groupValue: listOf,
                            onChanged: (value) {
                              setDialogState(() {
                                listOf = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await pickAndUploadCSVFile(listOf);
                      },
                      child: const Text("Pick CSV"),
                    ),
                  ],
                );
              },
            ),
          );
        },
        child: const Icon(Icons.upload_file, color: Colors.white),
      )
          : null,
    );
  }

  Future<void> pickAndUploadCSVFile(String status) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final rows = const CsvToListConverter().convert(content, eol: '\n');

        if (rows.isEmpty || rows.first.length < 9) {
          throw Exception("CSV format invalid or missing headers.");
        }

        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];

          await FirebaseFirestore.instance.collection('officers_detail').add({
            'serPA': row[0].toString(),
            'paNo': row[1].toString(),
            'rank': row[2].toString(),
            'name': row[3].toString(),
            'coursePresent': row[4].toString(),
            'unitPresent': row[5].toString(),
            'addressPresent': row[6].toString(),
            'addressPermanent': row[7].toString(),
            'whatsappContact': row[8].toString(),
            'status': status,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV uploaded successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}


class OfficerCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const OfficerCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            radius: 24.r,
            child: Text(
              data['name']?[0]?.toUpperCase() ?? '',
              style: TextStyle(fontSize: 20.sp, color: Colors.green),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Name & Rank
                Text(
                  '${data['rank'] ?? ''} ${data['name'] ?? ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 6.h),

                /// Course or Present Unit
                if (data.containsKey('coursePresent'))
                  _buildInfoLine('Course:', data['coursePresent']),
                if (data.containsKey('unitPresent'))
                  _buildInfoLine('Unit:', data['unitPresent']),

                /// Addresses
                if (data.containsKey('addressPresent'))
                  _buildInfoLine('Present Address:', data['addressPresent']),
                if (data.containsKey('addressPermanent'))
                  _buildInfoLine('Permanent Address:', data['addressPermanent']),

                /// WhatsApp
                if (data.containsKey('whatsappContact'))
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16.sp, color: Colors.green),
                      SizedBox(width: 6.w),
                      Text(
                        data['whatsappContact'] ?? '',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),

                /// Remarks (Retired only)
                if (data.containsKey('remarks'))
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      'Remarks: ${data['remarks']}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLine(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: value ?? '',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
