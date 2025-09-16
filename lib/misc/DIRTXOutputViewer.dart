import 'dart:io';
import 'package:dirtx/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DIRTXOutputViewer extends StatefulWidget {
  final String? backendOutputDir;
  final String placeholderAssetPath;

  const DIRTXOutputViewer({
    super.key,
    required this.backendOutputDir,
    this.placeholderAssetPath = 'assets/images/no-input-footage-found.png',
  });

  @override
  State<DIRTXOutputViewer> createState() => _DIRTXOutputViewerState();
}

class _DIRTXOutputViewerState extends State<DIRTXOutputViewer> {
  File? _imageFile;
  File? _videoFile;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _loading = true;
  String? _error;

  static const imageExts = ['.png', '.jpg', '.jpeg'];
  static const videoExts = ['.mp4'];

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant DIRTXOutputViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backendOutputDir != widget.backendOutputDir) {
      _disposeVideo();
      _imageFile = null;
      _videoFile = null;
      _error = null;
      _loading = true;
      _prepare();
    }
  }

  Future<void> _prepare() async {
    final dirPath = widget.backendOutputDir;
    if (dirPath == null || dirPath.isEmpty) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        setState(() {
          _error = 'Output folder not found';
          _loading = false;
          print(dir);
        });
        return;
      }

      final ents = dir.listSync().whereType<File>().toList();
      // sort by name or by modified time if you want:
      ents.sort((a, b) => a.path.compareTo(b.path));

      // pick first image if any (but ignore generated thumbnails like "thumb.*")
      for (final f in ents) {
        final fileName = f.uri.pathSegments.last.toLowerCase();
        final ext = f.path.toLowerCase();

        if (fileName.startsWith('thumb.')) {
          // skip generated thumbnail files
          continue;
        }

        if (imageExts.any((e) => ext.endsWith(e))) {
          _imageFile = f;
          break;
        }
      }

      // if no image, pick first video
      if (_imageFile == null) {
        for (final f in ents) {
          final ext = f.path.toLowerCase();
          if (videoExts.any((e) => ext.endsWith(e))) {
            _videoFile = f;
            break;
          }
        }
      }

      if (_videoFile != null) {
        await _initVideo(_videoFile!);
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error reading folder: $e';
        _loading = false;
      });
    }
  }

  Future<void> _initVideo(File file) async {
    _disposeVideo();
    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
      showControls: true,
      allowedScreenSleep: false,
      materialProgressColors: ChewieProgressColors(playedColor: DIRTXAppColorScheme.rustMedium)
    );
  }

  void _disposeVideo() {
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Image.asset(widget.placeholderAssetPath, fit: BoxFit.cover),
      );
    }

    if (_chewieController != null) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    }

    // no media found, show placeholder
    return Image.asset(widget.placeholderAssetPath, fit: BoxFit.cover);
  }
}
