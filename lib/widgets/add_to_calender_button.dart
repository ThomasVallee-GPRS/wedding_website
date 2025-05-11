import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddToGoogleCalendarButton extends StatelessWidget {
  final String title;
  final DateTime start;
  final DateTime end;
  final String location;
  final String details;

  const AddToGoogleCalendarButton({
    super.key,
    required this.title,
    required this.start,
    required this.end,
    required this.location,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final startString = _formatDateTime(start);
        final endString = _formatDateTime(end);

        final googleCalendarUrl =
            'https://calendar.google.com/calendar/render'
            '?action=TEMPLATE'
            '&text=${Uri.encodeComponent(title)}'
            '&dates=$startString/$endString'
            '&location=${Uri.encodeComponent(location)}'
            '&details=${Uri.encodeComponent(details)}';

        if (await canLaunchUrl(Uri.parse(googleCalendarUrl))) {
          await launchUrl(Uri.parse(googleCalendarUrl));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open Google Calendar")),
          );
        }
      },
      child: const Text("Add to Calendar",
      style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      ),
    );
  }

  // Helper to format your DateTime in "YYYYMMDDTHHMMSS" for a Google Calendar link
  String _formatDateTime(DateTime dateTime) {
    // For best results, use UTC or ensure correct timezone logic:
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    // Return local times (no 'Z') or universal times with 'Z'
    // If you want UTC time, do: dateTime.toUtc() first, then append 'Z'
    return '$year$month${day}T$hour$minute$second';
  }
}