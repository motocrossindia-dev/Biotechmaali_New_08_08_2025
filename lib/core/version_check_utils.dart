import 'package:url_launcher/url_launcher.dart';
import 'package:new_version_plus/new_version_plus.dart';

void launchStoreUrl(VersionStatus status) async {
  final url = status.appStoreLink;
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
