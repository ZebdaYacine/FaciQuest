import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:objectid/objectid.dart';

Future<void> showBuyTargetedResponsesModal(BuildContext context, {CollectorEntity? collector}) async {
  try {
    // Get the cubit reference before opening the modal to avoid accessing deactivated context
    final cubit = context.read<NewSurveyCubit>();
    final defaultCollector = collector ?? _createDefaultCollector(cubit);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      builder: (BuildContext _) {
        return BlocProvider.value(
          value: cubit,
          child: BuyTargetedResponsesModal(
            collector: defaultCollector,
          ),
        );
      },
    );
  } catch (e) {
    debugPrint('Error showing modal: $e');
    // Show error snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error.error_showing_modal'.tr(args: [e.toString()]))),
      );
    }
  }
}

CollectorEntity _createDefaultCollector(NewSurveyCubit cubit) {
  try {
    final survey = cubit.state.survey;

    return CollectorEntity(
      id: ObjectId().hexString,
      surveyId: survey.id ?? 'fallback',
      name: '',
      status: CollectorStatus.draft,
      responsesCount: 0,
      viewsCount: 0,
    );
  } catch (e) {
    debugPrint('Error creating default collector: $e');
    // Return a fallback collector
    return const CollectorEntity(
      id: 'null',
      surveyId: 'fallback',
      name: '',
      status: CollectorStatus.draft,
      responsesCount: 0,
      viewsCount: 0,
    );
  }
}

class BuyTargetedResponsesModal extends StatefulWidget {
  const BuyTargetedResponsesModal({
    super.key,
    required this.collector,
  });
  final CollectorEntity collector;

  @override
  State<BuyTargetedResponsesModal> createState() => _BuyTargetedResponsesModalState();
}

class _BuyTargetedResponsesModalState extends State<BuyTargetedResponsesModal> {
  late final NewSurveyCubit _cubit;
  late final TextEditingController _nameController;

  // Targeting state
  double _population = 200;
  Gender _gender = Gender.both;
  RangeValues _ageRange = const RangeValues(18, 99);
  Set<String> _countries = {'Algeria'};
  Set<Province> _provinces = {};
  Set<City> _cities = {};
  Set<TargetingCriteria> _selectedCriteria = {};

  @override
  void initState() {
    super.initState();
    try {
      _cubit = context.read<NewSurveyCubit>();
      _nameController = TextEditingController(text: widget.collector.name);
      // Initialize with existing collector data if available
      if (widget.collector.type == CollectorType.targetAudience) {
        _population = (widget.collector.population ?? 200.0).clamp(0.0, 5000.0);
        _gender = widget.collector.gender ?? Gender.both;
        _ageRange = widget.collector.ageRange ?? const RangeValues(18, 99);
        _countries = Set.from(widget.collector.countries.where((c) => c.isNotEmpty) ?? ['Algeria']);
        _provinces = Set.from(widget.collector.provinces.where((p) => p.name.isNotEmpty ?? false) ?? []);
        _cities = Set.from(widget.collector.cities.where((c) => c.name.isNotEmpty ?? false) ?? []);
        _selectedCriteria = Set.from(widget.collector.targetingCriteria.where((c) => c.title.isNotEmpty) ?? []);
      }
    } catch (e) {
      debugPrint('Error initializing state: $e');
      // Show error snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error.error_initializing'.tr(args: [e.toString()]))),
        );
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<double?> get _estimatedPrice async {
    try {
      return await _cubit.estimatePrice(
        widget.collector.copyWith(
          type: CollectorType.targetAudience,
          population: _population,
          gender: _gender,
          ageRange: _ageRange,
          countries: _countries.toList(),
          provinces: _provinces.toList(),
          cities: _cities.toList(),
          targetingCriteria: _selectedCriteria.toList(),
        ),
      );
    } catch (e) {
      debugPrint('Error estimating price: $e');
      return null;
    }
  }

  Set<String> get _selectedCountries {
    try {
      return {
        ..._countries,
        ..._provinces.map((e) => e.name ?? ''),
        ..._cities.map((e) => e.name ?? ''),
      };
    } catch (e) {
      debugPrint('Error getting selected countries: $e');
      return {'error.generic'.tr()};
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      title: Text(
        'collectors.buy_targeted.title'.tr(),
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNameField(),
            AppSpacing.spacing_3.heightBox,
            _buildPopulationCard(),
            AppSpacing.spacing_3.heightBox,
            _buildTargetingCard(),
          ],
        ),
      ),
      actions: _buildCheckoutSection(),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'collectors.buy_targeted.collector_name'.tr(),
          hintText: 'collectors.buy_targeted.enter_name'.tr(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPopulationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPopulationIcon(),
            AppSpacing.spacing_2.heightBox,
            Text(
              'collectors.buy_targeted.responses_needed'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.spacing_2.heightBox,
            _buildPopulationSlider(),
            _buildPopulationInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulationIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.people_outline_rounded,
        size: 48,
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildPopulationSlider() {
    return Slider(
      value: _population.clamp(0, 5000),
      min: 0,
      label: '${_population.round()}',
      max: 5000,
      onChanged: (value) {
        setState(() {
          _population = value;
        });
      },
    );
  }

  Widget _buildPopulationInput() {
    return InputQty(
      maxVal: 5000,
      initVal: _population,
      steps: 10,
      minVal: 0,
      decoration: QtyDecorationProps(
        isBordered: false,
        minusBtn: Icon(
          Icons.remove_circle_outline,
          color: context.colorScheme.primary,
          size: 28,
        ),
        plusBtn: Icon(
          Icons.add_circle_outline,
          color: context.colorScheme.primary,
          size: 28,
        ),
      ),
      onQtyChanged: (value) {
        setState(() {
          _population = value;
        });
      },
    );
  }

  Widget _buildTargetingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          AppSpacing.spacing_3.heightBox,
          Text(
            'collectors.buy_targeted.who_to_survey'.tr(),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.spacing_2.heightBox,
          _buildAddCriteriaButton(),
          AppSpacing.spacing_1.heightBox,
          _buildTargetingTiles(),
          AppSpacing.spacing_1.heightBox,
        ],
      ),
    );
  }

  Widget _buildAddCriteriaButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton.icon(
        onPressed: _handleAddCriteria,
        icon: const Icon(Icons.add),
        label: Text('collectors.buy_targeted.add_criteria'.tr()),
      ),
    );
  }

  Widget _buildTargetingTiles() {
    return Column(
      children: [
        _buildTargetingTile(
          icon: Icons.language,
          title: 'collectors.targeting.country_title'.tr(),
          subtitle: _selectedCountries.join(', '),
          onTap: _handleCountrySelection,
        ),
        _buildTargetingTile(
          icon: Icons.male,
          title: 'collectors.targeting.gender_title'.tr(),
          subtitle: _gender.name,
          onTap: _handleGenderSelection,
        ),
        _buildTargetingTile(
          icon: Icons.people_outline,
          title: 'collectors.targeting.age_range_title'.tr(),
          subtitle: '${_ageRange.start.round()} - ${_ageRange.end.round()}',
          onTap: _handleAgeSelection,
        ),
        for (final criteria in _selectedCriteria)
          _buildTargetingTile(
            icon: Icons.flag,
            title: criteria.title,
            subtitle: criteria.choices.join(', '),
          ),
      ],
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow(),
          AppSpacing.spacing_2.heightBox,
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'collectors.buy_targeted.estimated_cost'.tr(),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        FutureBuilder<double?>(
          future: _estimatedPrice,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'collectors.buy_targeted.error_loading_price'.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Text(
              '${snapshot.data?.toStringAsFixed(2).replaceAll('.', ',') ?? '----'} DZD',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: _handleCheckout,
      child: Text('collectors.buy_targeted.proceed_checkout'.tr()),
    );
  }

  Widget _buildTargetingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: Icon(icon, color: context.colorScheme.primary),
          trailing: onTap != null
              ? Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurfaceVariant,
                )
              : null,
          dense: true,
          title: Text(
            title,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }

  Future<void> _handleAddCriteria() async {
    try {
      if (!mounted) return;

      final result = await showTargetingCriteriaModal(context);
      if (result != null && mounted) {
        // Filter out invalid criteria
        final validCriteria = result.where((c) => c.title.isNotEmpty && c.choices.isNotEmpty).toSet();

        setState(() {
          _selectedCriteria = validCriteria;
        });
      }
    } catch (e) {
      debugPrint('Error adding criteria: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error.error_adding_criteria'.tr(args: [e.toString()]))),
        );
      }
    }
  }

  Future<void> _handleCountrySelection() async {
    try {
      if (!mounted) return;

      final result = await showModalBottomSheet(
        context: context,
        builder: (context) => const CountryModal(),
      );

      if (result != null && result is Map && mounted) {
        final countries = result['countries'];
        final provinces = result['provinces'];
        final cities = result['cities'];

        if (countries is Set<String> && provinces is Set<Province> && cities is Set<City>) {
          setState(() {
            _countries = countries.where((c) => c.isNotEmpty).toSet();
            _provinces = provinces.where((p) => p.name.isNotEmpty ?? false).toSet();
            _cities = cities.where((c) => c.name.isNotEmpty ?? false).toSet();
          });
        }
      }
    } catch (e) {
      debugPrint('Error selecting country: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error.error_selecting_country'.tr(args: [e.toString()]))),
        );
      }
    }
  }

  Future<void> _handleGenderSelection() async {
    try {
      if (!mounted) return;

      final result = await showModalBottomSheet(
        context: context,
        builder: (context) => const GenderModal(),
      );

      if (result != null && result is Gender && mounted) {
        setState(() {
          _gender = result;
        });
      }
    } catch (e) {
      debugPrint('Error selecting gender: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error.error_selecting_gender'.tr(args: [e.toString()]))),
        );
      }
    }
  }

  Future<void> _handleAgeSelection() async {
    try {
      if (!mounted) return;

      final result = await showModalBottomSheet(
        context: context,
        builder: (context) => const AgeModal(),
      );

      if (result != null && result is RangeValues && mounted) {
        // Validate age range
        final validRange = RangeValues(
          result.start.clamp(0, 120),
          result.end.clamp(result.start, 120),
        );
        setState(() {
          _ageRange = validRange;
        });
      }
    } catch (e) {
      debugPrint('Error selecting age: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error.error_selecting_age'.tr(args: [e.toString()]))),
        );
      }
    }
  }

  void _handleCheckout() async {
    try {
      if (!mounted) return;

      // Validate required fields
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('collectors.buy_targeted.enter_name'.tr())),
        );
        return;
      }

      if (_population <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('collectors.buy_targeted.responses_needed'.tr())),
        );
        return;
      }

      final collector = widget.collector.copyWith(
        name: _nameController.text.trim(),
        type: CollectorType.targetAudience,
        population: _population.clamp(1.0, 5000.0),
        gender: _gender,
        ageRange: _ageRange,
        countries: _countries.where((c) => c.isNotEmpty).toList(),
        provinces: _provinces.where((p) => p.name.isNotEmpty ?? false).toList(),
        cities: _cities.where((c) => c.name.isNotEmpty ?? false).toList(),
        targetingCriteria: _selectedCriteria.where((c) => c.title.isNotEmpty).toList(),
      );

      await _cubit.createCollector(collector);

      if (mounted) {
        final price = await _estimatedPrice;
        if (price is double && context.mounted) {
          await showPaymentModal(
            context,
            price: price,
            collectorId: collector.id,
          );
        }
      }
    } catch (e) {
      debugPrint('Error during checkout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('error.error_during_checkout'.tr(args: [e.toString()])),
        ));
      }
    }
  }
}
