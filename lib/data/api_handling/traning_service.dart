import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'api_path_constant.dart';

class TrainingService {
  TrainingService._internalConstructor();

  static final TrainingService _instance =
      TrainingService._internalConstructor();

  factory TrainingService() {
    return _instance;
  }

  Future<bool> training(
      {required Map<String, List<String>> trainingModelMap,
      required String id,
      required String jwt}) async {
    List<MultipartFile> imageMultipartFiles = [];
    List<MultipartFile> labelMultipartFiles = [];

    List<String> keys = trainingModelMap.keys.toList();
    for (var key in keys) {
      int count = 0;
      for (var path in trainingModelMap[key]!) {
        count++;

        String fileName = '${key.toLowerCase()}$count';
        String imageFileName = '$fileName.${path.split('.').last}';
        log(imageFileName);

        imageMultipartFiles
            .add(MultipartFile.fromFileSync(path, filename: imageFileName));

        final Directory directory = await getApplicationDocumentsDirectory();
        String txtFileName = '$fileName.txt';
        String txtFilePath = '${directory.path}/$txtFileName';
        log(txtFileName);
        log(txtFilePath);
        final File file = File(txtFilePath);
        String txtContent =
            '${labelList.indexOf(key.toLowerCase())} 0.5 0.5 1.0 1.0';
        log(txtContent);
        await file.writeAsString(txtContent).then((value) =>
            labelMultipartFiles.add(
                MultipartFile.fromFileSync(value.path, filename: txtFileName)));
      }
    }

    FormData formData = FormData.fromMap({
      'id': id,
      'images': imageMultipartFiles,
      'labels': labelMultipartFiles,
    });

    Response response = await Dio().post(
      'http://${APIPathConstant.API_SERVER_PATH}/api/v1/detect/upload-multi-data',
      data: formData,
      options: Options(
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'multipart/form-data',
          HttpHeaders.authorizationHeader: 'Bearer $jwt',
        },
      ),
    );
    log(response.data.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return true;
      default:
        return false;
    }
  }
}

final List<String> labelList = [
  "person",
  "bicycle",
  "car",
  "motorcycle",
  "airplane",
  "bus",
  "train",
  "truck",
  "boat",
  "traffic light",
  "fire hydrant",
  "stop sign",
  "parking meter",
  "bench",
  "bird",
  "cat",
  "dog",
  "horse",
  "sheep",
  "cow",
  "elephant",
  "bear",
  "zebra",
  "giraffe",
  "backpack",
  "umbrella",
  "handbag",
  "tie",
  "suitcase",
  "frisbee",
  "skis",
  "snowboard",
  "sports ball",
  "kite",
  "baseball bat",
  "baseball glove",
  "skateboard",
  "surfboard",
  "tennis racket",
  "bottle",
  "wine glass",
  "cup",
  "fork",
  "knife",
  "spoon",
  "bowl",
  "banana",
  "apple",
  "sandwich",
  "orange",
  "broccoli",
  "carrot",
  "hot dog",
  "pizza",
  "donut",
  "cake",
  "chair",
  "couch",
  "potted plant",
  "bed",
  "dining table",
  "toilet",
  "tv",
  "laptop",
  "mouse",
  "remote",
  "keyboard",
  "cell phone",
  "microwave",
  "oven",
  "toaster",
  "sink",
  "refrigerator",
  "book",
  "clock",
  "vase",
  "scissors",
  "teddy bear",
  "hair drier",
  "toothbrush"
];
