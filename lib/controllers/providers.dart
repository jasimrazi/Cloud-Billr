import 'package:cloud_billr/controllers/dashboard_provider.dart';
import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/controllers/customer_provider.dart';
import 'package:cloud_billr/controllers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => DashboardProvider()),
  ChangeNotifierProvider(create: (_) => CompanyProvider()),
  ChangeNotifierProvider(create: (_) => InvoiceProvider()),
  ChangeNotifierProvider(create: (_) => CustomerProvider()),
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
];
