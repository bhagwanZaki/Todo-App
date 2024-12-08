import 'dart:async';
import 'dart:io';

import 'package:todo/service/feedback_service.dart';
import 'package:todo/utils/api_response.dart';

class FeedbackStream {
  late FeedbackService _service;

  // controller
  late StreamController<ApiResponse<bool>> _controller;

  // sink
  StreamSink<ApiResponse<bool>> get feedbackSink => _controller.sink;

  // stream
  Stream<ApiResponse<bool>> get feedbackStream => _controller.stream;

  // constructor
  FeedbackStream() {
    _service = FeedbackService();
    _controller = StreamController<ApiResponse<bool>>();
  }

  // methods
  createFeedback(File uploadedImage, String feedback) async {
    feedbackSink.add(ApiResponse.loading("Calling feedback api"));
    try {
      bool data = await _service.createFeedbackApi(uploadedImage, feedback);
      feedbackSink.add(ApiResponse.completed(data));
    } catch (e) {
      feedbackSink.add(ApiResponse.error(e.toString()));
    }
  }
}
