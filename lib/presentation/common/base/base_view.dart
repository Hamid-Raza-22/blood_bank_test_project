import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_viewmodel.dart';
import '../widgets/loading_widget.dart';

/// Base View class providing common functionality for all views.
/// Extends GetView for automatic controller access.
abstract class BaseView<T extends BaseViewModel> extends GetView<T> {
  const BaseView({super.key});

  /// Override to provide the main content widget
  Widget buildContent(BuildContext context);

  /// Override to customize the app bar (optional)
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Override to customize the floating action button (optional)
  Widget? buildFab(BuildContext context) => null;

  /// Override to customize the bottom navigation bar (optional)
  Widget? buildBottomNavigationBar(BuildContext context) => null;

  /// Override to customize the drawer (optional)
  Widget? buildDrawer(BuildContext context) => null;

  /// Override to customize the scaffold background color (optional)
  Color? get backgroundColor => null;

  /// Override to handle loading state differently
  Widget buildLoading(BuildContext context) {
    return const LoadingWidget();
  }

  /// Override to handle error state differently
  Widget buildError(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Override to handle retry action
  void onRetry() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: backgroundColor,
      floatingActionButton: buildFab(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      drawer: buildDrawer(context),
      body: Obx(() {
        if (controller.isLoading) {
          return buildLoading(context);
        }
        if (controller.hasError) {
          return buildError(context, controller.error!);
        }
        return buildContent(context);
      }),
    );
  }
}

/// Simple view without reactive state checking
abstract class SimpleView<T extends GetxController> extends GetView<T> {
  const SimpleView({super.key});
}
