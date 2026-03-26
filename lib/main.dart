import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'src/app/george_loots_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable runtime font fetching but don't block startup
  GoogleFonts.config.allowRuntimeFetching = true;
  
  // Set system UI overlay style for faster rendering
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );
  
  // Run app immediately - fonts will load in background
  runApp(const GeorgeLootsApp());
}
