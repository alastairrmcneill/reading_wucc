import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_wucc/models/models.dart';
import 'package:reading_wucc/notifiers/notifiers.dart';
import 'package:reading_wucc/services/services.dart';

class NewEventForm extends StatefulWidget {
  const NewEventForm({Key? key}) : super(key: key);

  @override
  State<NewEventForm> createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String _name = '';
  late DateTime _startDate;
  DateTime? _pickedStartDate;
  late DateTime _endDate;
  DateTime? _pickedEndDate;

  Future _createEvent(UserNotifier userNotifier) async {
    Event neweEvent = Event(
      name: _name.trim(),
      startDate: _startDate,
      endDate: _endDate,
      admins: [userNotifier.currentUser!.uid],
      members: [],
    );
    await EventDatabase.createEvent(userNotifier, neweEvent);
  }

  Widget _buildNameInput() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      maxLines: 1,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
      },
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  Widget _buildStartDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _startDateController,
        decoration: const InputDecoration(
          labelText: 'Event Start Date',
        ),
        readOnly: true,
        onTap: () async {
          _pickedStartDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (_pickedStartDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(_pickedStartDate!);

            setState(() {
              _startDateController.text = formattedDate;
            });
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
        },
        onSaved: (value) {
          _startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
        },
      ),
    );
  }

  Widget _buildEndDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _endDateController,
        decoration: const InputDecoration(
          labelText: 'Event End Date',
        ),
        readOnly: true,
        onTap: () async {
          _pickedEndDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (_pickedEndDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(_pickedEndDate!);

            setState(() {
              _endDateController.text = formattedDate;
            });
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
        },
        onSaved: (value) {
          _endDate = DateFormat('dd/MM/yyyy').parse(_endDateController.text);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNameInput(),
              _buildStartDatePicker(),
              _buildEndDatePicker(),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              _formKey.currentState!.save();

              _createEvent(userNotifier);
            },
            child: Text('Save'))
      ],
    );
  }
}