/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traith/screens/admin/upload_event_screen.dart';
import 'package:traith/utils/color.dart';


class EventScreen extends StatefulWidget {
  final bool isAdmin;
  const EventScreen({super.key,required this.isAdmin});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Events', style: TextStyle(fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No events yet", style: TextStyle(fontSize: 18.sp)));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data()! as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.w),
                    leading: data['imageUrl'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        data['imageUrl'],
                        width: 70.w,
                        height: 70.h,
                        fit: BoxFit.cover,
                      ),
                    )
                        : null,
                    title: Text(data['title'] ?? '', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(data['time'] ?? '', style: TextStyle(fontSize: 14.sp)),
                        Text(data['location'] ?? '', style: TextStyle(fontSize: 14.sp)),
                        SizedBox(height: 4.h),
                        Text(
                          data['description'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text('Contact: ${data['contact'] ?? ''}', style: TextStyle(fontSize: 13.sp, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: widget.isAdmin?FloatingActionButton(
        backgroundColor: AppColor.greenColor,
        child: Icon(Icons.add, size: 28.sp),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadPostScreen()),
          );
        },
      ):null,
    );
  }
}
*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traith/screens/admin/upload_event_screen.dart';
import 'package:traith/utils/color.dart';

class EventScreen extends StatefulWidget {
  final bool isAdmin;
  const EventScreen({super.key, required this.isAdmin});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Events', style: TextStyle(fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text("No events yet",
                      style: TextStyle(fontSize: 18.sp)));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data()! as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data['imageUrl'] != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  data['imageUrl'],
                                  width: 70.w,
                                  height: 70.h,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.broken_image));
                                  },
                                ),
                              ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['title'] ?? '',
                                      style: TextStyle(
                                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4.h),
                                  Text(data['time'] ?? '', style: TextStyle(fontSize: 14.sp)),
                                  Text(data['location'] ?? '', style: TextStyle(fontSize: 14.sp)),
                                  SizedBox(height: 4.h),
                                  Text(
                                    data['description'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text('Contact: ${data['contact'] ?? ''}',
                                      style:
                                      TextStyle(fontSize: 13.sp, color: Colors.grey[700])),
                                ],
                              ),
                            ),
                            if (widget.isAdmin)
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                                onPressed: () {
                                  _confirmDelete(doc.id);
                                },
                              ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showFeedbackSheet(context, doc.id);
                            },
                            child: Text('View Feedback',
                                style: TextStyle(color: AppColor.greenColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        backgroundColor: AppColor.greenColor,
        child: Icon(Icons.add, size: 28.sp),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadPostScreen()),
          );
        },
      )
          : null,
    );
  }

  void _confirmDelete(String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(eventId)
                  .delete();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  void _showFeedbackSheet(BuildContext context, String eventId) {
    final TextEditingController feedbackController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16.h,
            left: 16.w,
            right: 16.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Feedback",
                  style:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .doc(eventId)
                    .collection('feedback')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No feedback yet",
                        style: TextStyle(fontSize: 14.sp));
                  }

                  final feedbackDocs = snapshot.data!.docs;
                  return SizedBox(
                    height: 200.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: feedbackDocs.length,
                      itemBuilder: (context, index) {
                        final feedback =
                        feedbackDocs[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(feedback['message'] ?? '',
                              style: TextStyle(fontSize: 14.sp)),
                          subtitle: Text(
                            feedback['timestamp']
                                .toString(),
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: "Write your feedback",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                minLines: 1,
                maxLines: 3,
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.whiteColor,
                ),
                onPressed: () async {
                  final message = feedbackController.text.trim();
                  if (message.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventId)
                        .collection('feedback')
                        .add({
                      'message': message,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    feedbackController.clear();
                  }
                },
                child: Text("Send Feedback", style: TextStyle(fontSize: 14.sp)),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}



/*return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: data['imageUrl'] != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              data['imageUrl'],
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.cover,
                            ),
                          )
                              : null,
                          title: Text(data['title'] ?? '',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text(data['time'] ?? '',
                                  style: TextStyle(fontSize: 14.sp)),
                              Text(data['location'] ?? '',
                                  style: TextStyle(fontSize: 14.sp)),
                              SizedBox(height: 4.h),
                              Text(
                                data['description'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text('Contact: ${data['contact'] ?? ''}',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey[700])),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showFeedbackSheet(context, doc.id);
                            },
                            child: Text('View Feedback',
                                style: TextStyle(color: AppColor.greenColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );*/

