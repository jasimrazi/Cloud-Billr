import 'package:cloud_billr/controllers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  // Add your providers here
  ChangeNotifierProvider(create: (_) => DashboardProvider()),
];
