// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class FaceDetectionCamera extends StatefulWidget {
//   @override
//   _FaceDetectionCameraState createState() => _FaceDetectionCameraState();
// }

// class _FaceDetectionCameraState extends State<FaceDetectionCamera> {
//   late CameraController _cameraController;
//   late FaceDetector _faceDetector;
//   StreamController<bool> _smileDetectionStreamController =
//       StreamController<bool>();

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _initializeFaceDetector();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );

//     await _cameraController.initialize();
//     if (!mounted) {
//       return;
//     }

//     setState(() {});
//   }

//   Future<void> _initializeFaceDetector() async {
//     _faceDetector = GoogleMlKit.vision.faceDetector(
//       FaceDetectorOptions(
//         enableClassification: true,
//         enableTracking: true,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return CameraPreview(_cameraController);
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector.close();
//     _smileDetectionStreamController.close();
//     super.dispose();
//   }

//   Future<void> _detectSmileInFrame(CameraImage image) async {
//     final inputImage = InputImage.fromBytes(
//         bytes: concatenatePlanes(image.planes),
//         inputImageData: InputImageData(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           imageRotation: InputImageRotation.Rotation_0deg,
//           inputFormat: InputImageFormatMethods.fromRawValue(image.format.raw),
//           metadata: InputImageMetadata(
//             planeData: image.planes.map((Plane plane) {
//               return InputImagePlaneMetadata(
//                 bytesPerRow: plane.bytesPerRow,
//                 height: plane.height,
//                 width: plane.width,
//               );
//             }).toList(),
//           ),
//         ));

//     final List<Face> faces = await _faceDetector.processImage(inputImage);

//     bool isSmiling = false;
//     for (Face face in faces) {
//       if (face.smilingProbability != null && face.smilingProbability > 0.7) {
//         isSmiling = true;
//         break;
//       }
//     }

//     _smileDetectionStreamController.sink.add(isSmiling);
//   }

//   Uint8List concatenatePlanes(List<Plane> planes) {
//     final WriteBuffer allBytes = WriteBuffer();
//     planes.forEach((plane) {
//       allBytes.putUint8List(plane.bytes);
//     });
//     return allBytes.done().buffer.asUint8List();
//   }
// }
