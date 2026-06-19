import 'package:expence_management/core/utils/shared_widgets/custom_card.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/home/controller/home_controller.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  // final HomeController controller = Get.find();

  Color _sectionCardColor(BuildContext context) {
    return Get.isDarkMode
        ? const Color(0xFF2A2A2A)
        : Theme.of(context).cardColor;
  }

  List<BoxShadow> _sectionCardShadow() {
    return Get.isDarkMode
        ? const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 16),
              blurRadius: 32,
            ),
          ]
        : const [
            BoxShadow(
              color: AppColors.shadowSoft,
              offset: Offset(0, 8),
              blurRadius: 30,
            ),
          ];
  }

  Color _sectionTextColor() {
    return Get.isDarkMode ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),

                Text(
                  "Welcome User",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 24),

                _buildBalanceCard(context),
                SizedBox(height: 8),

                _buildCategoryCard(context),

                _buildWeeklyChartCard(context),
                _buildMonthlyFlowCard(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(150),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              // Add action here
              Get.toNamed(AppRoutes.addTransaction);
            },
            backgroundColor: AppColors.primary,
            elevation: 0, // IMPORTANT: we use custom shadow instead
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF00BD85)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primarySoft,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Balance",
              style: const TextStyle(fontSize: 14, color: AppColors.white),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${controller.totalBalance.value.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _smallInfoCard(
                    context,
                    "Income",
                    controller.totalIncome.value,
                    AppColors.mintAccent,
                    Icons.arrow_downward,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _smallInfoCard(
                    context,
                    "Expense",
                    controller.totalExpense.value,
                    AppColors.homeExpenseSoft,
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              width: 143,
              height: 130,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _sectionCardColor(context),
                borderRadius: BorderRadius.circular(30),
                boxShadow: _sectionCardShadow(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.savings_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Savings",
                        style: TextStyle(
                          color: _sectionTextColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${controller.totalSavings.value}",
                    style: TextStyle(
                      color: _sectionTextColor(),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallInfoCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: 143,
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _sectionCardColor(context),
        borderRadius: BorderRadius.circular(30),
        boxShadow: _sectionCardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: _sectionTextColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              color: _sectionTextColor(),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: _sectionCardColor(context),
      borderColor: Get.isDarkMode
          ? const Color(0x33000000)
          : AppColors.borderHalf,
      boxShadow: _sectionCardShadow(),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: _sectionTextColor(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // SizedBox(
          //   height: 200,
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       CircularProgressIndicator(value: 1, strokeWidth: 5),
          //       const Text(
          //         "100%",
          //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),
          // _circularProgressWidget(),
          // Container(
          //   width: 112,
          //   height: 112,
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: AppColors.white,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: LinearGradient(
          //         begin: AlignmentGeometry.topCenter,
          //         end: AlignmentGeometry.bottomCenter,
          //         colors: [AppColors.black.withOpacity(0.05), AppColors.transparent],
          //       ),
          //     ),
          //   ),
          // ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.black.withOpacity(0.05),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Inner white circle
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                alignment: Alignment.center,
                child: Obx(
                  () => Text(
                    controller.categoryData.isEmpty ? '0%' : '100%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Obx(
            () => Column(
              children: controller.categoryData.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: category.color,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: _sectionTextColor(),
                          ),
                        ),
                      ),

                      Text(
                        "${category.percentage.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _sectionTextColor(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChartCard(BuildContext context) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return CustomCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: _sectionCardColor(context),
      borderColor: Get.isDarkMode
          ? const Color(0x33000000)
          : AppColors.borderHalf,
      boxShadow: _sectionCardShadow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Weekly Spending",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _sectionTextColor(),
                ),
              ),
              // SizedBox(width: 40),
              // Container(
              //   // alignment: Alignment.centerRight,
              //   height: 20,
              //   width: 75,
              //   decoration: BoxDecoration(
              //     // background: #EDEEEF;
              //     color: AppColors.inputFill,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Text("This Week"),
              // ),
            ],
          ),
          const SizedBox(height: 10),

          Obx(() {
            final data = controller.weeklySpending;
            if (data.isEmpty) {
              return SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    "No data",
                    style: TextStyle(color: _sectionTextColor()),
                  ),
                ),
              );
            }
            if (data.every((e) => e == 0)) {
              return SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    'No spending data this week',
                    style: TextStyle(color: _sectionTextColor()),
                  ),
                ),
              );
            }

            // final maxValue = data.reduce((a, b) => a > b ? a : b);
            // final maxY = maxValue * 1.2;
            // final maxY = (data.reduce((a, b) => a > b ? a : b) * 1.2);
            final rawMaxY = data.reduce((a, b) => a > b ? a : b);
            final maxY = rawMaxY <= 0 ? 10.0 : rawMaxY * 1.2;

            return SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: maxY,

                  // ❌ REMOVE LEFT TITLES
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1, // 🔥 prevents double labels
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value > 6) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : AppColors.lightSecondaryText,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxY / 4).clamp(1.0, double.infinity),
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: AppColors.shadowHome,
                      strokeWidth: 1,
                    ),
                  ),

                  borderData: FlBorderData(show: false),

                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        data.length,
                        (i) => FlSpot(i.toDouble(), data[i]),
                      ),
                      isCurved: true,
                      barWidth: 3,
                      color: AppColors.glowGreen,
                      dotData: const FlDotData(show: false),

                      // 🔥 GRADIENT FILL (dark top → light bottom)
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.glowGreenSoft, // darker top
                            AppColors.glowGreenLight, // lighter bottom
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMonthlyFlowCard(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
      backgroundColor: _sectionCardColor(context),
      borderColor: Get.isDarkMode
          ? const Color(0x33000000)
          : AppColors.borderHalf,
      boxShadow: _sectionCardShadow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Monthly Flow",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: _sectionTextColor(),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "In",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _sectionTextColor(),
                ),
              ),

              const SizedBox(width: 16),

              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.white54 : AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "Out",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _sectionTextColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          Obx(() {
            final data = controller.monthlyFlow;
            final maxY = _getMaxMonthlyY(data);

            return SizedBox(
              height: 240,
              child: Stack(
                children: [
                  // 🔥 CHART
                  BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          // tooltipBgColor: AppColors.primary,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '\$${rod.toY.toStringAsFixed(0)}',
                              const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),

                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 80,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= data.length) {
                                return const SizedBox();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Text(
                                  data[value.toInt()].month,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      barGroups: List.generate(data.length, (index) {
                        final item = data[index];

                        return BarChartGroupData(
                          x: index,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: item.income,
                              width: 24,
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            BarChartRodData(
                              toY: item.expense,
                              width: 24,

                              // background: #E1E3E4;
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  // 🔥 SEPARATOR LINE (REAL DIVIDER)
                  Positioned(
                    bottom: 50, // 👈 adjust until it sits between bars & labels
                    left: 10,
                    right: 10,
                    child: Container(height: 1, color: AppColors.shadowMedium),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  double _getMaxMonthlyY(List data) {
    double maxValue = 0;

    for (var item in data) {
      if (item.income > maxValue) maxValue = item.income;
      if (item.expense > maxValue) maxValue = item.expense;
    }

    return maxValue + 5000; // padding
  }
}
