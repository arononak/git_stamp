import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showSnackbar({
  required BuildContext context,
  required String message,
  bool floating = true,
  bool showCloseIcon = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      closeIconColor: Colors.white,
      showCloseIcon: showCloseIcon,
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      duration: floating ? Duration(seconds: 3) : Duration(seconds: 15),
      backgroundColor: Colors.orange.withOpacity(0.9),
      content: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSnackbar(
    context: context,
    message: 'Copied to clipboard!',
    showCloseIcon: true,
  );
}
