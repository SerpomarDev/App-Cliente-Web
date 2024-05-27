import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/providers/products_provider.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';
import 'dart:async';

class LookerController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;
  RxBool isActive = false.obs;
  RxMap<String, int> categoryCounts = {
    '1': 0,
    '2': 0,
    '3': 0,
    '4': 0,
  }.obs;

  RxMap<String, int> containerCounts = <String, int>{}.obs;
  RxMap<String, int> requestsByDay = <String, int>{}.obs;
  RxInt totalNumContainers = 0.obs;
  RxBool isLoading = false.obs;

  final ProductsProvider _productsProvider = ProductsProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchContainerCountsForToday();
    fetchInitialData();
  }

  Future<void> fetchContainerCountsForToday() async {
    isLoading.value = true;
    try {
      Map<String, int> containerCounts = await _productsProvider.fetchContainerCountsByCategoryToday();
      if (containerCounts.isNotEmpty) {
        this.containerCounts.value = containerCounts;
        totalNumContainers.value = containerCounts.values.reduce((a, b) => a + b); // Suma todos los valores de los contenedores
      }
    } catch (e) {
      print('Error fetching container counts by category for today: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    await fetchTodaysData();
    await Future.wait([
      updateRequestsByDayData(),
      fetchCategoryCounts(DateFormat('yyyy-MM-dd').format(DateTime.now())),
      fetchDestinationCounts(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchTodaysData() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await Future.wait([
      updateRequestsByDayData(),
      fetchCategoryCounts(today),
      fetchDestinationCounts(),
    ]);
  }

  Future<void> fetchContainerCounts() async {
    isLoading.value = true;
    try {
      Map<String, int> containerCounts = await _productsProvider.fetchContainerCountsByCategory();
      if (containerCounts.isNotEmpty) {
        this.containerCounts.value = containerCounts;
      }
    } catch (e) {
      print('Error fetching container counts by category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    isLoading.value = true;
    await Future.wait([
      updateRequestsByDayData(),
      fetchCategoryCounts(DateFormat('yyyy-MM-dd').format(DateTime.now())),
      fetchDestinationCounts(),
      fetchContainerCountsForToday(),
    ]);
    isLoading.value = false;
  }

  Future<void> updateRequestsByDayData() async {
    try {
      Map<String, int> counts = await _productsProvider.countRequestsByDay();
      if (counts.isNotEmpty) {
        requestsByDay.value = counts;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryCounts(String date) async {
    isLoading.value = true;
    print("Fetching category counts for date: $date");
    try {
      Map<String, int> newCounts = await _productsProvider.fetchProductCountsByCategoryAndDate(date);
      if (newCounts.isNotEmpty) {
        categoryCounts.value = newCounts;
        print("Fetched category counts: $newCounts");
      } else {
        print("No data available for category counts on $date");
      }
    } catch (e) {
      print('Error fetching category counts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDestinationCounts() async {
    isLoading.value = true;
    try {
      Map<int, int> counts = await _ordersProvider.getDestinationReachedCounts();
      print('Fetched destination counts: $counts'); // Debug log
      if (counts.isNotEmpty) {
        destinationCounts.value = counts;
      } else {
        print('No data available for destination counts');
      }
    } catch (e) {
      print('Error fetching destination counts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  RxMap<int, int> destinationCounts = <int, int>{}.obs;

  Future<void> updateContainerCounts(DateTimeRange range) async {
    isLoading.value = true;
    String startDate = DateFormat('yyyy-MM-dd').format(range.start);
    String endDate = DateFormat('yyyy-MM-dd').format(range.end);
    List<Product> products = await _productsProvider.findByDateRange(startDate, endDate);
    totalNumContainers.value = products.fold(0, (sum, item) => sum + (item.numContainers ?? 0));
    isLoading.value = false;
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }
}
