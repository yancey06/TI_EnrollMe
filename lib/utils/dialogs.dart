import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showAppDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showAppSnackbar(BuildContext context, String message, {Color? color, IconData? icon}) {
  final theme = Theme.of(context);
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: color ?? const Color(0xFF22223B),
    elevation: 10,
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.5),
    ),
    content: Row(
      children: [
        if (icon != null)
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: const Color(0xFF3D5AFE), size: 24),
          ),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
} 