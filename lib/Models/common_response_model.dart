abstract class ResponsModel {}

class EmptyResponse implements ResponsModel {}

class UnAuthorizedResponse implements ResponsModel {}

class ServerErrorResponse implements ResponsModel {}

class ForbiddenResponse implements ResponsModel {}

class ConflictResponse implements ResponsModel {}

class BadRequestResponse implements ResponsModel {
  final List<String> listErrors;

  BadRequestResponse({required this.listErrors});
}
