import 'dart:math';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/core/widgets/response_distribution_analyzer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Widget that displays response distribution charts based on the analysis
class ResponseDistributionChart extends StatelessWidget {
  final ResponseDistribution distribution;

  const ResponseDistributionChart({
    super.key,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    if (distribution.distributionItems.isEmpty) {
      return const _EmptyDistributionWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        16.heightBox,
        SizedBox(
          height: 300,
          child: _buildChart(context),
        ),
        16.heightBox,
        _buildStatistics(context),
        16.heightBox,
        _buildLegend(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          distribution.question.type.icon,
          size: 20,
          color: context.colorScheme.primary,
        ),
        8.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                distribution.question.title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${distribution.totalResponses} responses',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    switch (distribution.chartType) {
      case ChartType.bar:
        return _BarChart(distribution: distribution);
      case ChartType.pie:
        return _PieChart(distribution: distribution);
      case ChartType.histogram:
        return _HistogramChart(distribution: distribution);
      case ChartType.matrix:
        return _MatrixChart(distribution: distribution);
    }
  }

  Widget _buildStatistics(BuildContext context) {
    final stats = distribution.statistics;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: 'Average',
              value: stats.average.toStringAsFixed(2),
              icon: Icons.trending_up_rounded,
            ),
          ),
          12.widthBox,
          Expanded(
            child: _StatItem(
              label: 'Median',
              value: stats.median.toStringAsFixed(2),
              icon: Icons.analytics_outlined,
            ),
          ),
          12.widthBox,
          Expanded(
            child: _StatItem(
              label: 'Most Popular',
              value: stats.mode ?? 'N/A',
              icon: Icons.star_outline_rounded,
            ),
          ),
          12.widthBox,
          Expanded(
            child: _StatItem(
              label: 'Std Dev',
              value: stats.standardDeviation.toStringAsFixed(2),
              icon: Icons.scatter_plot_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    if (distribution.distributionItems.length <= 6) {
      return Wrap(
        spacing: 16,
        runSpacing: 8,
        children: distribution.distributionItems.map((item) {
          final color = _getColorForIndex(distribution.distributionItems.indexOf(item));
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              8.widthBox,
              Text(
                '${item.label} (${item.percentage.toStringAsFixed(1)}%)',
                style: context.textTheme.bodySmall,
              ),
            ],
          );
        }).toList(),
      );
    }

    return Text(
      'Legend shows top responses. Full data available in detailed view.',
      style: context.textTheme.bodySmall?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}

class _BarChart extends StatelessWidget {
  final ResponseDistribution distribution;

  const _BarChart({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final sortedItems = List<DistributionItem>.from(distribution.distributionItems)
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxValue = sortedItems.isNotEmpty ? sortedItems.first.value : 0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY: maxValue * 1.1,
        barGroups: sortedItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.value,
                color: _getColorForIndex(index),
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: context.textTheme.bodySmall,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedItems.length) {
                  final item = sortedItems[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      item.label.length > 10 ? '${item.label.substring(0, 10)}...' : item.label,
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxValue / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.colorScheme.outlineVariant.withOpacity(0.5),
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}

class _PieChart extends StatelessWidget {
  final ResponseDistribution distribution;

  const _PieChart({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final sortedItems = List<DistributionItem>.from(distribution.distributionItems)
      ..sort((a, b) => b.value.compareTo(a.value));

    return PieChart(
      PieChartData(
        sections: sortedItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final color = _getColorForIndex(index);

          return PieChartSectionData(
            value: item.value,
            title: '${item.percentage.toStringAsFixed(1)}%',
            radius: 80,
            color: color,
            titleStyle: context.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            badgeWidget: item.percentage > 5
                ? _Badge(
                    '${item.value.toInt()}',
                    borderColor: color,
                  )
                : null,
            badgePositionPercentageOffset: 1.3,
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}

class _HistogramChart extends StatelessWidget {
  final ResponseDistribution distribution;

  const _HistogramChart({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final maxValue =
        distribution.distributionItems.isNotEmpty ? distribution.distributionItems.map((e) => e.value).reduce(max) : 0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY: maxValue * 1.1,
        barGroups: distribution.distributionItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.value,
                color: Colors.blue.withOpacity(0.8),
                width: 30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: context.textTheme.bodySmall,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < distribution.distributionItems.length) {
                  final item = distribution.distributionItems[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      item.label,
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxValue / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.colorScheme.outlineVariant.withOpacity(0.5),
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }
}

class _MatrixChart extends StatelessWidget {
  final ResponseDistribution distribution;

  const _MatrixChart({required this.distribution});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: max(400, distribution.distributionItems.length * 60.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: distribution.distributionItems.isNotEmpty
                ? distribution.distributionItems.map((e) => e.value).reduce(max) * 1.1
                : 0,
            barGroups: distribution.distributionItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: item.value,
                    color: _getColorForIndex(index),
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 80,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < distribution.distributionItems.length) {
                      final item = distribution.distributionItems[value.toInt()];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            item.label.length > 15 ? '${item.label.substring(0, 15)}...' : item.label,
                            style: context.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: context.colorScheme.primary,
        ),
        4.heightBox,
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        2.heightBox,
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color borderColor;

  const _Badge(this.text, {required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: borderColor,
        ),
      ),
    );
  }
}

class _EmptyDistributionWidget extends StatelessWidget {
  const _EmptyDistributionWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outlineVariant,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: context.colorScheme.onSurfaceVariant,
            ),
            16.heightBox,
            Text(
              'No responses yet',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            8.heightBox,
            Text(
              'Charts will appear when responses are collected',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
