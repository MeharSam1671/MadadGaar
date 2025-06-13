import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  // Sample list of requests including ambulance dispatches
  final List<UserRequest> userRequests = [
    // Ambulance requests with status success or cancelled
    UserRequest(
      title: "Ambulance Dispatch - City Hospital",
      dateTime: DateTime.now().subtract(Duration(days: 2, hours: 3)),
      status: RequestStatus.success,
    ),
    UserRequest(
      title: "Ambulance Dispatch - Green Clinic",
      dateTime: DateTime.now().subtract(Duration(days: 5, hours: 1)),
      status: RequestStatus.cancelled,
    ),

    // Other user requests
    UserRequest(
      title: "Ambulance Request - City Hospital",
      dateTime: DateTime.now().subtract(Duration(days: 1, hours: 2)),
      status: RequestStatus.completed,
    ),
    UserRequest(
      title: "Blood Test Appointment",
      dateTime: DateTime.now().subtract(Duration(days: 3)),
      status: RequestStatus.cancelled,
    ),
    UserRequest(
      title: "Follow-up Consultation",
      dateTime: DateTime.now().subtract(Duration(hours: 5)),
      status: RequestStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request History"),
      ),
      body: userRequests.isEmpty
          ? const Center(
        child: Text("No requests found."),
      )
          : ListView.builder(
        itemCount: userRequests.length,
        itemBuilder: (context, index) {
          final request = userRequests[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(request.title),
              subtitle: Text(
                "Date: ${formatDate(request.dateTime)}\nStatus: ${_getStatusDisplay(request.status)}",
              ),
              isThreeLine: true,
              leading: Icon(
                _getStatusIcon(request.status),
                color: _getStatusColor(request.status),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to detailed view or take action
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: theme.colorScheme.error,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
          // You can add more navigation logic here
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
        "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  // Display friendly status names
  String _getStatusDisplay(RequestStatus status) {
    switch (status) {
      case RequestStatus.completed:
        return "Completed";
      case RequestStatus.pending:
        return "Pending";
      case RequestStatus.cancelled:
        return "Cancelled";
      case RequestStatus.success:
        return "Success";
    }
  }

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.completed:
        return Icons.check_circle_outline;
      case RequestStatus.pending:
        return Icons.pending_actions;
      case RequestStatus.cancelled:
        return Icons.cancel;
      case RequestStatus.success:
        return Icons.local_hospital;  // ambulance/health icon for success
    }
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.cancelled:
        return Colors.red;
      case RequestStatus.success:
        return Colors.blue;  // distinct blue color for ambulance success
    }
  }
}

enum RequestStatus { completed, pending, cancelled, success }

class UserRequest {
  final String title;
  final DateTime dateTime;
  final RequestStatus status;

  UserRequest({
    required this.title,
    required this.dateTime,
    required this.status,
  });
}
