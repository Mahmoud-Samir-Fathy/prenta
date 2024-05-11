import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() => _instance;

  PermissionService._internal();

  // Request permission to access the photo library (external storage)
  Future<bool> requestPhotosPermission() async {
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  // Check if the photo library permission (external storage) is granted
  Future<bool> hasPhotosPermission() async {
    final storageStatus = await Permission.storage.status;
    return storageStatus.isGranted;
  }
}
