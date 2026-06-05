import 'package:expence_management/core/utils/shared_widgets/custom_card.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/home/controller/home_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  // final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F9FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),

                const Text(
                  "Welcome User",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 24),

                _buildBalanceCard(),
                SizedBox(height: 8),

                _buildCategoryCard(),

                _buildWeeklyChartCard(),
                _buildMonthlyFlowCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006C49), Color(0xFF005236)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26006C49), // #006C4926
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Balance",

              // background: #FFFFFFCC;
              style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${controller.totalBalance.value.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _smallInfoCard(
                    "Income",
                    controller.totalIncome.value,

                    //background: #6FFBBE;
                    Color(0xFF6FFBBE),
                    Icons.arrow_downward,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _smallInfoCard(
                    "Expense",
                    controller.totalExpense.value,

                    //background: #FFDAD6;
                    Color(0xFFFFDAD6),
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.savings_outlined, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        "Savings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${controller.totalSavings.value}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // add icon
              Icon(icon, color: color, size: 20),
              Text(
                title,
                style: TextStyle(
                  color: color,
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
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
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
          //     color: Colors.white,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: LinearGradient(
          //         begin: AlignmentGeometry.topCenter,
          //         end: AlignmentGeometry.bottomCenter,
          //         colors: [Colors.black.withOpacity(0.05), Colors.transparent],
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
                  color: Colors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.transparent,
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
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '100%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Obx(
            () => Column(
              spacing: 12,
              children: controller.categoryData.map((category) {
                return Row(
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
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    Text(
                      "${category.percentage.toStringAsFixed(0)}%",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChartCard() {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Weekly Spending",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              // SizedBox(width: 40),
              // Container(
              //   // alignment: Alignment.centerRight,
              //   height: 20,
              //   width: 75,
              //   decoration: BoxDecoration(
              //     // background: #EDEEEF;
              //     color: Color(0xFFEDEEEF),
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
              return const SizedBox(
                height: 180,
                child: Center(child: Text("No data")),
              );
            }

            // final maxValue = data.reduce((a, b) => a > b ? a : b);
            // final maxY = maxValue * 1.2;
            final maxY = (data.reduce((a, b) => a > b ? a : b) * 1.2);

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
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,

                                // background: #3C4A42;
                                color: Color(0xFF3C4A42),
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
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (value) =>
                        const FlLine(color: Color(0x11000000), strokeWidth: 1),
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
                      color: const Color(0xFF4EDEA3),
                      dotData: const FlDotData(show: false),

                      // 🔥 GRADIENT FILL (dark top → light bottom)
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x804EDEA3), // darker top
                            Color.fromARGB(16, 199, 245, 223), // lighter bottom
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

  Widget _buildMonthlyFlowCard() {
    return CustomCard(
      padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Flow",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
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
              const Text(
                "In",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),

              const SizedBox(width: 16),

              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE1E3E4),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "Out",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                              color: Color(0xFFE1E3E4),
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
                    child: Container(height: 1, color: const Color(0x22000000)),
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
