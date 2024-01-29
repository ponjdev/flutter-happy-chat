// import 'dart:io';
// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class CameraPreviewWidget extends StatefulWidget {
//   final CameraDescription cameraInstance;
//   final CameraController cameraController;

//   CameraPreviewWidget(
//       {required this.cameraController, required this.cameraInstance});

//   @override
//   _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
// }

// class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
//   late FaceDetector faceDetector;
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };

//   @override
//   void initState() {
//     faceDetector = FaceDetector.faceDetector();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     faceDetector.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.cameraController.value.isInitialized) {
//       return Container(); // Return an empty container while the camera is initializing
//     }

//     return AspectRatio(
//       aspectRatio: widget.cameraController.value.aspectRatio,
//       child: CameraPreview(widget.cameraController),
//     );
//   }

//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     // get image rotation
//     // it is used in android to convert the InputImage from Dart to Java
//     // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
//     // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
//     final camera = widget.cameraInstance;
//     final sensorOrientation = camera.sensorOrientation;
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//           _orientations[widget.cameraController.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         // back-facing
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//     }
//     if (rotation == null) return null;

//     // get image format
//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     if (image.planes.length != 1) return null;
//     final plane = image.planes.first;

//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation, // used only in Android
//         format: format, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }

//   Future<void> _detectSmileInFrame(CameraImage image) async {
//     final inputImage = _inputImageFromCameraImage(image);

//     try {
//       final faces = await faceDetector.processImage(inputImage!);

//       // Check if anyone is smiling
//       bool isAnyoneSmiling = faces.any((face) =>
//           face.smilingProbability != null && face.smilingProbability! > 0.5);

//       // Take action when a smile is detected
//       if (isAnyoneSmiling) {
//         // Do something when a smile is detected
//       }
//     } catch (e) {
//       print('Error detecting faces: $e');
//     }
//   }

//   // Uint8List _concatenatePlanes(List<Plane> planes) {
//   //   // Concatenate the Y, U, and V planes into a single byte buffer
//   //   // ...

//   //   return concatenatedBuffer;
//   // }
// }
