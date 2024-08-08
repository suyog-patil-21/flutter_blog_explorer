enum CustomExceptionMessage {
  noInternet('No Internet Available'),
  canNotFindData('Cannot find data'),
  somethingWhenWorng('Something when wrong');

  final String name;
  const CustomExceptionMessage(this.name);
}

class CustomException {
  final String message;
  CustomException(this.message);
  @override
  String toString() {
    return message;
  }
}
