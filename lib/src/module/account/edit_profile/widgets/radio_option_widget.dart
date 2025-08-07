import '../../../../../import.dart';

class RadioOptionWidget extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?>? onChanged;

  const RadioOptionWidget({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
