import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:objectid/objectid.dart';

Future<void> showBuyTargetedResponsesModal(BuildContext context,
    {CollectorEntity? collector}) async {
  try {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      builder: (BuildContext _) {
        return BlocProvider.value(
          value: context.read<NewSurveyCubit>(),
          child: BuyTargetedResponsesModal(
            collector: collector ?? _createDefaultCollector(context),
          ),
        );
      },
    );
  } catch (e) {
    debugPrint('Error showing modal: $e');
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error showing modal: $e')),
    );
  }
}

CollectorEntity _createDefaultCollector(BuildContext context) {
  try {
    final cubit = context.read<NewSurveyCubit>();
    final survey = cubit.state.survey;

    return CollectorEntity(
      id: ObjectId().hexString,
      surveyId: survey.id,
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
  State<BuyTargetedResponsesModal> createState() =>
      _BuyTargetedResponsesModalState();
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
        _population = widget.collector.population ?? 200;
        _gender = widget.collector.gender ?? Gender.male;
        _ageRange = widget.collector.ageRange ?? const RangeValues(18, 99);
        _countries = Set.from(widget.collector.countries ?? ['Algeria']);
        _provinces = Set.from(widget.collector.provinces ?? []);
        _cities = Set.from(widget.collector.cities ?? []);
        _selectedCriteria = Set.from(widget.collector.targetingCriteria ?? []);
      }
    } catch (e) {
      debugPrint('Error initializing state: $e');
      // Show error snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing: $e')),
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
        ..._provinces.map((e) => e.name),
        ..._cities.map((e) => e.name),
      };
    } catch (e) {
      debugPrint('Error getting selected countries: $e');
      return {'Error loading countries'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      title: Text(
        'Buy targeted responses',
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ).tr(),
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
          labelText: 'Collector Name',
          hintText: 'Enter a name for this collector',
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
              'How many responses do you need?',
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
            'Who do you want to survey?',
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
        label: const Text('Add targeting criteria'),
      ),
    );
  }

  Widget _buildTargetingTiles() {
    return Column(
      children: [
        _buildTargetingTile(
          icon: Icons.language,
          title: 'Country',
          subtitle: _selectedCountries.join(', '),
          onTap: _handleCountrySelection,
        ),
        _buildTargetingTile(
          icon: Icons.male,
          title: 'Gender',
          subtitle: _gender.name,
          onTap: _handleGenderSelection,
        ),
        _buildTargetingTile(
          icon: Icons.people_outline,
          title: 'Age Range',
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
          'Estimated cost',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        FutureBuilder<double?>(
          future: _estimatedPrice,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Error',
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
      child: const Text('Proceed to Checkout'),
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
      final result = await showTargetingCriteriaModal(context);
      if (result != null) {
        setState(() {
          _selectedCriteria = result;
        });
      }
    } catch (e) {
      debugPrint('Error adding criteria: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding criteria: $e')),
      );
    }
  }

  Future<void> _handleCountrySelection() async {
    try {
      final result = await showModalBottomSheet(
        context: context,
        builder: (context) => const CountryModal(),
      );

      if (result != null && result is Map) {
        setState(() {
          _countries = result['countries'] as Set<String>;
          _provinces = result['provinces'] as Set<Province>;
          _cities = result['cities'] as Set<City>;
        });
      }
    } catch (e) {
      debugPrint('Error selecting country: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting country: $e')),
      );
    }
  }

  Future<void> _handleGenderSelection() async {
    try {
      final result = await showModalBottomSheet(
        context: context,
        builder: (context) => const GenderModal(),
      );
      if (result != null && result is Gender) {
        setState(() {
          _gender = result;
        });
      }
    } catch (e) {
      debugPrint('Error selecting gender: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting gender: $e')),
      );
    }
  }

  Future<void> _handleAgeSelection() async {
    try {
      final result = await showModalBottomSheet(
        context: context,
        builder: (context) => const AgeModal(),
      );
      if (result != null && result is RangeValues) {
        setState(() {
          _ageRange = result;
        });
      }
    } catch (e) {
      debugPrint('Error selecting age: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting age: $e')),
      );
    }
  }

  void _handleCheckout() {
    try {
      _cubit.createCollector(
        widget.collector.copyWith(
          name: _nameController.text,
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
      showPaymentModal(context);
    } catch (e) {
      debugPrint('Error during checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during checkout: $e')),
      );
    }
  }
}
