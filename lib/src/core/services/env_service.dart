import 'package:envied/envied.dart';

part 'env_service.g.dart';

@Envied(path: '.env')
abstract class EnvService {
  @EnviedField(varName: 'PROJECT_URL', obfuscate: true)
  static final String projectUrl = _EnvService.projectUrl;
  @EnviedField(varName: 'ANON_KEY', obfuscate: true)
  static final String anonKey = _EnvService.anonKey;
  @EnviedField(varName: 'ENCRYPTION_KEY', obfuscate: true)
  static final String encryptionKey = _EnvService.encryptionKey;
}
