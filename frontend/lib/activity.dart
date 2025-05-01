import 'package:flutter/material.dart';

class ActivityPhotoAid extends StatelessWidget {
  const ActivityPhotoAid({super.key});

  final List<Activity> activities = const [
    Activity(
      name: 'Alex Johnson',
      role: 'Photographer',
      location: 'New York',
      namerequest: 'Anh Quoc Ngo',
      datetime: 'Mar 18, 2025 - 8:00 AM',
      status: 'Processing',
    ),
    Activity(
      name: 'Emily Carter',
      role: 'Photographer',
      location: 'Chicago',
      namerequest: 'Anh Quoc Ngo',
      datetime: 'Apr 2, 2025 - 5:30 PM',
      status: 'Completed',
    ),
    Activity(
      name: 'Anh Quoc Ngo',
      role: 'Photographer',
      location: 'Houston',
      namerequest: 'Ronaldo',
      datetime: 'Apr 10, 2025 - 9:00 AM',
      status: 'Completed',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('Activity', style: TextStyle(color: Colors.black))
      ),
      body: ListView.builder(
        itemCount: activities.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(activity.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(activity.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          activity.status,
                          style: TextStyle(
                            color: _getStatusColor(activity.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(activity.role,
                      style: TextStyle(color: Colors.grey[700])),
                          Text(activity.location,
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 4),
                  Text(activity.datetime, style: TextStyle(color: Colors.grey[600])),
                  Text(activity.namerequest, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Activity {
  final String name;
  final String role;
  final String location;
  final String namerequest;
  final String datetime;
  final String status;

  const Activity({
    required this.name,
    required this.role,
    required this.location,
    required this.namerequest,
    required this.datetime,
    required this.status,
  });
}
