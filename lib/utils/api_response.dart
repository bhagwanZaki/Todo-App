// ignore_for_file: constant_identifier_names

class ApiResponse<T> {
  late Status status;
  late T data;
  late String msg;

  ApiResponse.loading(this.msg) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.DONE;
  ApiResponse.error(this.msg) : status = Status.ERROR;
  ApiResponse.active() : status = Status.ACTIVE;

  @override
  String toString() {
    return "Status: $status, DATA: $data, MESSAGE: $msg";
  }
}

enum Status { LOADING, DONE, ERROR, ACTIVE }
