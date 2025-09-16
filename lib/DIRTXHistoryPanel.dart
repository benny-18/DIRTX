import 'dart:io';
import 'package:dirtx/main.dart';
import 'package:dirtx/misc/DIRTXFlaskBackend.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:path/path.dart' as p;

class DIRTXHistoryPanel extends StatefulWidget {
  const DIRTXHistoryPanel({super.key});

  @override
  State<DIRTXHistoryPanel> createState() => _DIRTXHistoryPanelState();
}

class _DIRTXHistoryPanelState extends State<DIRTXHistoryPanel> {
  final _thumbPlugin = FcNativeVideoThumbnail();
  final _win = p.Context(style: p.Style.windows);

  late Directory outputDir;
  List<Directory> detectionFolders = [];
  int? selectedIndex;

  bool newestFirst = true;

  @override
  void initState() {
    super.initState();
    _loadDetectionFolders();
  }

  // ---- helpers -------------------------------------------------------------

  String _winNormalize(String path) {
    final normalized = _win.normalize(path);
    return normalized.replaceAll('/', '\\');
  }

  bool _isImageExt(String ext) =>
      const {'jpg', 'jpeg', 'png', 'bmp', 'webp', 'gif'}.contains(ext);

  bool _isVideoExt(String ext) =>
      const {'mp4', 'avi', 'mov', 'mkv'}.contains(ext);

  // ---- Data load -----------------------------------------------------------

  Future<void> _loadDetectionFolders() async {
    final docsDir = Directory(r"C:\Users\User\Documents\DIRTX\outputs");
    if (!await docsDir.exists()) {
      setState(() => detectionFolders = []);
      return;
    }

    final dirs = docsDir
        .listSync()
        .whereType<Directory>()
        .toList();

    // comparator using file timestamps (modified), fallback to name-based
    int comparator(Directory a, Directory b) {
      try {
        final aTime = a.statSync().modified;
        final bTime = b.statSync().modified;
        return newestFirst ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
      } catch (e) {
        // fallback to lexicographic
        return newestFirst ? b.path.compareTo(a.path) : a.path.compareTo(b.path);
      }
    }

    dirs.sort(comparator);

    if (kDebugMode) {
      debugPrint('Loaded ${dirs.length} folders (newestFirst=$newestFirst)');
      for (var i = 0; i < dirs.length && i < 6; i++) {
        debugPrint('  ${i + 1}: ${dirs[i].path}  modified=${dirs[i].statSync().modified}');
      }
    }

    setState(() {
      outputDir = docsDir;
      detectionFolders = dirs;
    });
  }


  // ---- Thumbnails ----------------------------------------------------------

  Future<Widget> _buildThumbnail(Directory folder) async {
    try {
      final cachedThumb = File(_win.join(folder.path, 'thumb.jpg'));
      if (await cachedThumb.exists()) {
        return Image.file(
          cachedThumb,
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }

      final files = folder
          .listSync()
          .whereType<File>()
          .where((f) {
        final ext = f.path.split('.').last.toLowerCase();
        return _isImageExt(ext) || _isVideoExt(ext);
      })
          .toList();

      if (files.isEmpty) {
        debugPrint("No media files found in ${folder.path}");
        return const Icon(Icons.broken_image, size: 80);
      }

      final media = files.first;
      final ext = media.path.split('.').last.toLowerCase();

      if (_isImageExt(ext)) {
        if (await media.exists()) {
          return Image.file(
            media,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        }
        debugPrint("Image not found: ${media.path}");
        return const Icon(Icons.broken_image, size: 80);
      }

      if (_isVideoExt(ext)) {
        final srcPath = _winNormalize(File(media.path).absolute.path);
        final destPath = _winNormalize(
          _win.join(Directory(folder.path).absolute.path, 'thumb.jpg'),
        );

        debugPrint("Generate thumb for: $srcPath -> $destPath");

        try {
          final ok = await _thumbPlugin.getVideoThumbnail(
            srcFile: srcPath,
            destFile: destPath,
            width: 300,
            height: 300,
            format: 'jpeg',
            quality: 90,
          );

          if (ok && await File(destPath).exists()) {
            return Image.file(
              File(destPath),
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          }

          debugPrint("Thumbnail not generated for: $srcPath");
          return const Icon(Icons.broken_image, size: 42);
        } on Exception catch (e, st) {
          final retrySrc = srcPath.replaceAll('/', '\\');
          final retryDest = destPath.replaceAll('/', '\\');
          debugPrint("Thumb gen error: $e, retry with $retrySrc");
          try {
            final ok2 = await _thumbPlugin.getVideoThumbnail(
              srcFile: retrySrc,
              destFile: retryDest,
              width: 300,
              height: 300,
              format: 'jpeg',
              quality: 90,
            );
            if (ok2 && await File(retryDest).exists()) {
              return Image.file(
                File(retryDest),
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            }
          } catch (e2, st2) {
            debugPrint("Retry failed for $retrySrc: $e2\n$st2");
          }
          debugPrint("Thumbnail error for ${folder.path}: $e\n$st");
          return const Icon(Icons.error, size: 80);
        }
      }

      return const Icon(Icons.insert_drive_file, size: 80);
    } catch (e, st) {
      debugPrint("Thumbnail error for ${folder.path}: $e\n$st");
      return const Icon(Icons.error, size: 80);
    }
  }

  // ---- Delete --------------------------------------------------------------

  Future<void> _deleteFolder(Directory folder) async {
    try {
      await folder.delete(recursive: true);
      setState(() {
        detectionFolders.removeWhere((d) => d.path == folder.path);
        if (selectedIndex != null && selectedIndex! >= detectionFolders.length) {
          selectedIndex = null;
        }
      });
    } catch (e) {
      debugPrint("Error deleting folder: $e");
    }
  }

  // ---- UI ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Detection history",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: DIRTXAppColorScheme.rustVibrant
                  )
              ),
              ToggleButtons(
                constraints: BoxConstraints(minHeight: 20, minWidth: 35),
                borderWidth: 1.0,
                borderRadius: BorderRadius.circular(6),
                selectedBorderColor: DIRTXAppColorScheme.rustMedium,
                isSelected: [newestFirst == true, newestFirst == false],
                onPressed: (index) {
                  final value = (index == 0);
                  setState(() {
                    newestFirst = value;
                  });

                  if (kDebugMode) {
                    debugPrint('Sort toggled: newestFirst=$newestFirst');
                  }

                  _loadDetectionFolders();
                },
                children: const [

                  Tooltip(message: "Newest first", child: Icon(Icons.move_up_rounded, size: 16)),
                  Tooltip(message: "Oldest first", child: Icon(Icons.move_down_rounded, size: 16))
                ],
              ),
            ],
          ),
        ),

        SizedBox.square(dimension: 12),

        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              itemCount: detectionFolders.length,
              itemBuilder: (context, index) {
                final folder = detectionFolders[index];
                final folderName = _win.basename(folder.path);

                return FutureBuilder<Widget>(
                  future: _buildThumbnail(folder),
                  builder: (context, snapshot) {
                    final thumbnail = switch (snapshot.connectionState) {
                      ConnectionState.done => snapshot.data ?? const Icon(Icons.broken_image),
                      _ => const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    };

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          backendOutputDirNotifier.value = detectionFolders[index].path;

                          // isLiveFeed = false;
                          isLiveFeedNotifier.value = false;
                          //for debuug
                          if (kDebugMode) {
                            print('Selected index: $index');
                            print('Output dir set to: ${backendOutputDirNotifier.value}');
                          }
                        });
                      },

                      child: Container(
                        key: ValueKey(folder.path),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: DIRTXAppColorScheme.rustLight,
                          border: selectedIndex == index
                              ? Border.all(color: DIRTXAppColorScheme.rustMedium, width: 2.0)
                              : Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Thumbnail
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: DIRTXAppColorScheme.rustLight,
                                    border: Border.all(
                                      color: DIRTXAppColorScheme.greyLight,
                                      width: 1.0,
                                      strokeAlign: BorderSide.strokeAlignOutside
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: thumbnail,
                                ),
                              ),

                              // Folder name + delete
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    folderName.replaceAll(".", ":"),
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteFolder(folder),
                                    icon: Icon(
                                      Icons.delete_forever_rounded,
                                      size: 17,
                                      color: DIRTXAppColorScheme.rustMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
