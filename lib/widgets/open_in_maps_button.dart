import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenInMapsButton extends StatelessWidget {
  final double latitude;
  final double longitude;

  const OpenInMapsButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Google Maps'),
            ),
          );
        }
      },
      child: const Text("Open in Maps",
      style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      ),
    );
  }
}