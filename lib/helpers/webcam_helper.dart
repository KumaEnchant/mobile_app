import 'dart:async';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class WebCamera {
  html.VideoElement? _video;
  html.MediaStream? _stream;
  html.DivElement? _container;
  html.DivElement? _buttonContainer;
  bool _isInitialized = false;
  final String containerId =
      'webcam-container-${DateTime.now().millisecondsSinceEpoch}';
  final String buttonContainerId =
      'webcam-buttons-${DateTime.now().millisecondsSinceEpoch}';

  Future<void> Function()? onCapture;
  Future<void> Function()? onCancel;

  void _disableFlutterClickLayer() {
    print("🔧 Disabling Flutter click layer...");

    // Method 1: By ID
    final ids = [
      'flt-glass-pane',
      'flt-scene-host',
      'flt-scene',
      'flt-platform-view',
      'flutter-view',
    ];

    for (var id in ids) {
      final el = html.document.getElementById(id);
      if (el != null) {
        el.style.pointerEvents = 'none';
        el.style.zIndex = '-1';
        print("  ✓ Disabled: $id");
      }
    }

    // Method 2: All canvas elements
    final canvases = html.document.getElementsByTagName('canvas');
    print("  Found ${canvases.length} canvas elements");
    for (var canvas in canvases) {
      (canvas as html.CanvasElement).style.pointerEvents = 'none';
      canvas.style.zIndex = '-1';
    }

    // Method 3: Query selector
    final sceneHost = html.document.querySelector('flt-scene-host');
    if (sceneHost != null) {
      (sceneHost as html.Element).style.pointerEvents = 'none';
      print("  ✓ Disabled flt-scene-host via querySelector");
    }

    print("✅ Flutter click layer disabled");
  }

  void _enableFlutterClickLayer() {
    print("🔧 Enabling Flutter click layer...");

    final ids = [
      'flt-glass-pane',
      'flt-scene-host',
      'flt-scene',
      'flt-platform-view',
      'flutter-view',
    ];

    for (var id in ids) {
      final el = html.document.getElementById(id);
      if (el != null) {
        el.style.pointerEvents = 'auto';
        el.style.zIndex = '0';
      }
    }

    final canvases = html.document.getElementsByTagName('canvas');
    for (var canvas in canvases) {
      (canvas as html.CanvasElement).style.pointerEvents = 'auto';
      canvas.style.zIndex = '0';
    }

    final sceneHost = html.document.querySelector('flt-scene-host');
    if (sceneHost != null) {
      (sceneHost as html.Element).style.pointerEvents = 'auto';
    }

    print("✅ Flutter click layer enabled");
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print("🎥 Initializing webcam...");

      _stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {
          'facingMode': 'user',
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
        },
        'audio': false,
      });

      print("✅ Camera access granted");

      _video = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.transform = 'scaleX(-1)';

      _video!.srcObject = _stream;

      // Container untuk video
      _container = html.DivElement()
        ..id = containerId
        ..style.position = 'fixed'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100vw'
        ..style.height = '100vh'
        ..style.zIndex = '999998'
        ..style.backgroundColor = '#000'
        ..style.display = 'none'
        ..style.pointerEvents = 'auto';

      _container!.append(_video!);

      // Container untuk button - SANGAT PENTING!
      _buttonContainer = html.DivElement()
        ..id = buttonContainerId
        ..style.position = 'fixed'
        ..style.bottom = '0'
        ..style.left = '0'
        ..style.width = '100vw'
        ..style.height = '200px'
        ..style.zIndex = '9999999' // SUPER HIGH!
        ..style.background =
            'linear-gradient(to top, rgba(0,0,0,0.9), transparent)'
        ..style.display = 'none'
        ..style.justifyContent = 'center'
        ..style.alignItems = 'center'
        ..style.paddingBottom = '40px'
        ..style.pointerEvents = 'auto';

      // === TOMBOL CAPTURE (Biru) ===
      final captureBtn = html.ButtonElement()
        ..style.width = '80px'
        ..style.height = '80px'
        ..style.borderRadius = '50%'
        ..style.border = 'none'
        ..style.backgroundColor = '#2196F3'
        ..style.cursor = 'pointer'
        ..style.boxShadow =
            '0 4px 20px rgba(33, 150, 243, 0.8), 0 0 0 4px rgba(255, 255, 255, 0.3)'
        ..style.transition = 'all 0.3s ease'
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'center'
        ..style.margin = '0 15px'
        ..style.position = 'relative'
        ..style.pointerEvents = 'auto'
        ..style.outline = 'none'
        ..text = '📸';

      captureBtn.style.fontSize = '32px';

      // TEST: Multiple event handlers
      captureBtn.onClick.listen((event) {
        print("🔵 [onClick] Capture button clicked!");
        event.stopPropagation();
        event.preventDefault();
        if (onCapture != null) {
          print("🔵 Calling onCapture...");
          onCapture!();
        } else {
          print("⚠️ onCapture is null!");
        }
      });

      captureBtn.onMouseDown.listen((event) {
        print("🔵 [onMouseDown] Capture button pressed!");
      });

      captureBtn.addEventListener('click', (event) {
        print("🔵 [addEventListener] Capture clicked!");
        event.stopPropagation();
        event.preventDefault();
        if (onCapture != null) {
          onCapture!();
        }
      });

      captureBtn.addEventListener('touchstart', (event) {
        print("🔵 [touchstart] Capture touched!");
        event.stopPropagation();
        event.preventDefault();
        if (onCapture != null) {
          onCapture!();
        }
      });

      // === TOMBOL CANCEL (Merah) ===
      final cancelBtn = html.ButtonElement()
        ..style.width = '60px'
        ..style.height = '60px'
        ..style.borderRadius = '50%'
        ..style.border = 'none'
        ..style.backgroundColor = '#F44336'
        ..style.cursor = 'pointer'
        ..style.boxShadow = '0 4px 15px rgba(244, 67, 54, 0.6)'
        ..style.transition = 'all 0.3s ease'
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'center'
        ..style.margin = '0 15px'
        ..style.position = 'relative'
        ..style.pointerEvents = 'auto'
        ..style.outline = 'none'
        ..text = '✕';

      cancelBtn.style.fontSize = '32px';
      cancelBtn.style.color = 'white';

      cancelBtn.onClick.listen((event) {
        print("🔴 [onClick] Cancel button clicked!");
        event.stopPropagation();
        event.preventDefault();
        if (onCancel != null) {
          print("🔴 Calling onCancel...");
          onCancel!();
        } else {
          print("⚠️ onCancel is null!");
        }
      });

      cancelBtn.onMouseDown.listen((event) {
        print("🔴 [onMouseDown] Cancel button pressed!");
      });

      cancelBtn.addEventListener('click', (event) {
        print("🔴 [addEventListener] Cancel clicked!");
        event.stopPropagation();
        event.preventDefault();
        if (onCancel != null) {
          onCancel!();
        }
      });

      cancelBtn.addEventListener('touchstart', (event) {
        print("🔴 [touchstart] Cancel touched!");
        event.stopPropagation();
        event.preventDefault();
        if (onCancel != null) {
          onCancel!();
        }
      });

      // Hover effects
      captureBtn.onMouseEnter.listen((_) {
        captureBtn.style.transform = 'scale(1.15)';
        print("🔵 Hover on capture button");
      });

      captureBtn.onMouseLeave.listen((_) {
        captureBtn.style.transform = 'scale(1)';
      });

      cancelBtn.onMouseEnter.listen((_) {
        cancelBtn.style.transform = 'scale(1.15)';
        print("🔴 Hover on cancel button");
      });

      cancelBtn.onMouseLeave.listen((_) {
        cancelBtn.style.transform = 'scale(1)';
      });

      // === INFO TEXT ===
      final infoText = html.DivElement()
        ..style.position = 'fixed'
        ..style.top = '40px'
        ..style.left = '50%'
        ..style.transform = 'translateX(-50%)'
        ..style.backgroundColor = 'rgba(0, 0, 0, 0.85)'
        ..style.color = 'white'
        ..style.padding = '16px 24px'
        ..style.borderRadius = '16px'
        ..style.fontSize = '15px'
        ..style.fontWeight = '600'
        ..style.zIndex = '9999999'
        ..style.display = 'none'
        ..style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.5)'
        ..style.border = '1px solid rgba(255, 255, 255, 0.1)'
        ..style.pointerEvents = 'none'
        ..text = '📸 Posisikan wajah Anda di tengah kamera';

      // === BUTTON WRAPPER ===
      final btnWrapper = html.DivElement()
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'center'
        ..style.pointerEvents = 'auto';

      btnWrapper.append(cancelBtn);
      btnWrapper.append(captureBtn);

      // === APPEND TO DOM ===
      html.document.body!.append(_container!);
      _buttonContainer!.append(btnWrapper);
      html.document.body!.append(_buttonContainer!);
      html.document.body!.append(infoText);

      _container!.dataset['infoTextId'] = infoText.id = 'info-$containerId';

      await _video!.onLoadedMetadata.first;
      await _video!.onCanPlay.first;

      _isInitialized = true;

      print("✅ Webcam initialized successfully");
      print("   - Container ID: $containerId");
      print("   - Button Container ID: $buttonContainerId");
      print("   - Callbacks set: ${onCapture != null && onCancel != null}");
    } catch (e) {
      print("❌ Error initializing webcam: $e");
      rethrow;
    }
  }

  void showPreview() {
    if (_container != null && _buttonContainer != null) {
      print("📹 Showing camera preview...");

      // Disable Flutter layer FIRST
      _disableFlutterClickLayer();

      // Wait a bit
      Future.delayed(Duration(milliseconds: 100), () {
        _container!.style.display = 'block';
        _buttonContainer!.style.display = 'flex';

        final infoTextId = _container!.dataset['infoTextId'];
        if (infoTextId != null) {
          final infoText = html.document.getElementById(infoTextId);
          if (infoText != null) {
            infoText.style.display = 'block';
          }
        }

        // Double check disable
        Future.delayed(Duration(milliseconds: 100), () {
          _disableFlutterClickLayer();
          
          // Log button state
          final btnContainer = html.document.getElementById(buttonContainerId);
          if (btnContainer != null) {
            print("✅ Button container visible: ${btnContainer.style.display}");
            print("✅ Button container z-index: ${btnContainer.style.zIndex}");
            print("✅ Button container pointer-events: ${btnContainer.style.pointerEvents}");
          }
          
          print("✅ Camera preview shown and ready");
        });
      });
    }
  }

  void hidePreview() {
    if (_container != null && _buttonContainer != null) {
      _container!.style.display = 'none';
      _buttonContainer!.style.display = 'none';

      final infoTextId = _container!.dataset['infoTextId'];
      if (infoTextId != null) {
        final infoText = html.document.getElementById(infoTextId);
        if (infoText != null) {
          infoText.style.display = 'none';
        }
      }

      _enableFlutterClickLayer();

      print("🔒 Camera preview hidden");
    }
  }

  Future<Uint8List> capture() async {
    if (!_isInitialized || _video == null) {
      throw Exception("Webcam belum diinisialisasi");
    }

    try {
      print("📸 Capturing photo...");

      if (_video!.videoWidth == 0 || _video!.videoHeight == 0) {
        throw Exception("Video belum ready, coba lagi");
      }

      final canvas = html.CanvasElement(
        width: _video!.videoWidth,
        height: _video!.videoHeight,
      );

      final ctx = canvas.context2D;

      ctx.save();
      ctx.scale(-1, 1);
      ctx.drawImageScaled(
          _video!, -canvas.width!, 0, canvas.width!, canvas.height!);
      ctx.restore();

      final blob = await canvas.toBlob('image/png');
      final reader = html.FileReader();
      reader.readAsArrayBuffer(blob);
      await reader.onLoad.first;

      final result = reader.result;
      Uint8List uint8List;

      if (result is ByteBuffer) {
        uint8List = result.asUint8List();
      } else if (result is Uint8List) {
        uint8List = result;
      } else {
        throw Exception("Unexpected type: ${result.runtimeType}");
      }

      print(
          "✅ Photo captured: ${uint8List.length} bytes (${canvas.width}x${canvas.height})");

      return uint8List;
    } catch (e) {
      print("❌ Error capturing photo: $e");
      rethrow;
    }
  }

  void dispose() {
    try {
      print("🛑 Disposing webcam...");

      _enableFlutterClickLayer();

      if (_stream != null) {
        final tracks = _stream!.getTracks();
        for (var track in tracks) {
          track.stop();
        }
      }

      _video?.remove();
      _video?.srcObject = null;
      _video = null;

      final infoTextId = _container?.dataset['infoTextId'];
      if (infoTextId != null) {
        html.document.getElementById(infoTextId)?.remove();
      }

      _container?.remove();
      _container = null;

      _buttonContainer?.remove();
      _buttonContainer = null;

      _stream = null;
      _isInitialized = false;

      print("✅ Webcam disposed");
    } catch (e) {
      print("⚠️ Error disposing webcam: $e");
    }
  }

  bool get isReady => _isInitialized && _video != null && _stream != null;
  int get width => _video?.videoWidth ?? 0;
  int get height => _video?.videoHeight ?? 0;
}