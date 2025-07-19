import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';

class PDFViewerWidget extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerWidget({required this.pdfUrl});

  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final ByteData data = await rootBundle.load(widget.pdfUrl);
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/temp.pdf');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      setState(() {
        localFilePath = tempFile.path;
      });
    } catch (e) {
      print("Error loading PDF: $e");
      setState(() {
        localFilePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: localFilePath != null
          ? PDFView(
              filePath: localFilePath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (_pages) {
                setState(() {});
              },
              onError: (error) {
                print("PDFView error: $error");
              },
              onPageError: (page, error) {
                print("Page error on page $page: $error");
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}