import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_website/widgets/add_to_calender_button.dart';
import 'package:wedding_website/widgets/open_in_maps_button.dart';
import 'package:wedding_website/widgets/web_viewer_widget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jesse & Tom 2025",
      // Define our light theme here using a pink color swatch.
      theme: ThemeData(
        brightness: Brightness.light,
        // Use a primary swatch for a consistent color palette.
        primarySwatch: Colors.pink,
        // Create a color scheme from a seed color.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 232, 233, 227),
        canvasColor: Colors.white,
        cardColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.5),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.pink[900],
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
        ),
        textTheme: const TextTheme(
          // Use headline1 for large titles.
          headlineLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
          // Headline6 can be used for smaller titles.
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          // BodyText1 for general text.
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(8),
        ),
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _countDownTimer;
  late DateTime weddingDate;
  late Duration timeLeft;

  @override
  void initState() {
    super.initState();

    // Target date/time
    weddingDate = DateTime(2025, 11, 15, 16, 0);

    // Initialize timeLeft
    timeLeft = weddingDate.difference(DateTime.now());

    // Set up a Timer that ticks every second
    _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = weddingDate.difference(now);

      if (difference.inSeconds <= 0) {
        // Time’s up
        setState(() {
          timeLeft = Duration.zero;
        });
        timer.cancel();
      } else {
        setState(() {
          timeLeft = difference;
        });
      }
    });
  }

  @override
  void dispose() {
    // Always cancel your timers to prevent leaks.
    _countDownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adjust font sizes based on device type.
    bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    bool isTablet = ResponsiveBreakpoints.of(context).isTablet;
    double titleFontSize = isDesktop ? 48 : isTablet ? 36 : 24;
    double subtitleFontSize = isDesktop ? 24 : isTablet ? 18 : 14;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxHeight * 0.5;
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    TitleCard(imageHeight: imageHeight, titleFontSize: titleFontSize),
                    const SizedBox(height: 16),
                    WhereSection(titleFontSize: titleFontSize, subtitleFontSize: subtitleFontSize),
                    const SizedBox(height: 16),
                    const HorizontalRule(),
                    const SizedBox(height: 16),
                    WhenSection(titleFontSize: titleFontSize, subtitleFontSize: subtitleFontSize, weddingDate: weddingDate, timeLeft: timeLeft),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalRule extends StatelessWidget {
  const HorizontalRule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: const Color.fromARGB(255, 60, 55, 55),
    );
  }
}

class WhenSection extends StatelessWidget {
  const WhenSection({
    super.key,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.weddingDate,
    required this.timeLeft,
  });

  final double titleFontSize;
  final double subtitleFontSize;
  final DateTime weddingDate;
  final Duration timeLeft;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("When",
            style: TextStyle(
              fontSize: titleFontSize * 1.5,
              fontWeight: FontWeight.bold,
              fontFamily: "DancingScript",
            )),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, color: Colors.black),
              const SizedBox(width: 8),
              Text("11/15/2025",
                  style: TextStyle(
                    fontSize: subtitleFontSize * 1.25,
                    fontFamily: GoogleFonts.croissantOne().fontFamily,
                  )),
            ],
          ),
        ),
        AddToGoogleCalendarButton(
            title: "Jesse & Tom 2025 Wedding",
            start: weddingDate,
            end: weddingDate.add(const Duration(hours: 4)),
            location: "Nantahala National Forest",
            details: "Jesse & Tom 2025 Wedding"),
        const SizedBox(height: 32),
        Text(
          "Countdown",
          style: TextStyle(
            fontSize: titleFontSize * 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: "DancingScript",
          ),
        ),
        const SizedBox(height: 16),
        Text(
          timeLeft.inSeconds <= 0
              ? "The big day has arrived!"
              : "${timeLeft.inDays}d: "
                  "${timeLeft.inHours % 24}h: "
                  "${timeLeft.inMinutes % 60}m: "
                  "${timeLeft.inSeconds % 60}s",
          style: TextStyle(
            fontSize: subtitleFontSize,
            fontFamily: GoogleFonts.croissantOne().fontFamily,
          ),
        ),
      ],
    );
  }
}

class WhereSection extends StatelessWidget {
  const WhereSection({
    super.key,
    required this.titleFontSize,
    required this.subtitleFontSize,
  });

  final double titleFontSize;
  final double subtitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Where",
            style: TextStyle(
              fontSize: titleFontSize * 1.5,
              fontWeight: FontWeight.bold,
              fontFamily: "DancingScript",
            )),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.location_on, color: Colors.black),
            const SizedBox(width: 8),
            Text("Nantahala National Forest",
                style: TextStyle(
                  fontSize: subtitleFontSize * 1.25,
                  fontFamily: GoogleFonts.croissantOne().fontFamily,
                )),
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                // url launcher
                launchUrl(Uri.parse("https://nantahalaweddings.com/mountain-top-wedding-ceremony/"));
              },
              child: Text(
                "Website",
                style: TextStyle(fontSize: subtitleFontSize, fontFamily: GoogleFonts.cabin().fontFamily, color: Colors.black, decoration: TextDecoration.underline),
              ),
            ),
            TextButton(
              onPressed: () {
                // url launcher
                launchUrl(Uri.parse("https://nantahalaweddings.com/lodging-lake-nantahala-wedding//"));
              },
              child: Text(
                "Lodging",
                style: TextStyle(fontSize: subtitleFontSize, fontFamily: GoogleFonts.cabin().fontFamily, color: Colors.black, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 200, child: VideoPlayerWidget()),
        const OpenInMapsButton(latitude: 35.18425867260464, longitude: -83.65518856691311),
      ],
    );
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.imageHeight,
    required this.titleFontSize,
  });

  final double imageHeight;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: imageHeight,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Image.asset(
                "assets/images/splash.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 130),
              Text(
                "Jesse & Tom",
                style: TextStyle(
                  fontSize: titleFontSize * 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DancingScript",
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "November 15, 2025",
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DancingScript",
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
