import 'package:college_management/app/base_view.dart';
import 'package:college_management/utils/string_utils.dart';
import 'package:college_management/view_models/auth/signup_view_model.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_pallete.dart';
import '../../core/models/faculty.dart';
import '../../core/models/student.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _batchNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _coNameController = TextEditingController();
  final TextEditingController _coPhoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sslcController = TextEditingController();
  final TextEditingController _plusTwoController = TextEditingController();
  final TextEditingController _bachelorsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _role = "";
  String _selectedCourse = "";
  String password = '';
  int formNumber = 1;
  bool isStudentRegistration = true;

  bool _isAllFieldsEmpty({required List<String?> fieldValues}) {
    return fieldValues.every((value) => StringUtils.isEmptyString(value));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<SignupViewModel>(
      refresh: (SignupViewModel model) {},
      builder: (context, model, child) {
        return SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: AppPalette.violetLt,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35))),
                  height: size.height / 6.5,
                ),
                formNumber == 1
                    ? basicDetailForm(
                        selectedRole: _role,
                        selectedCourse: _selectedCourse,
                        onRoleSelection: (val) {
                          if (val == "Faculty") {
                            setState(() {
                              _role = val;
                              isStudentRegistration = false;
                            });
                          }
                        },
                        size: size,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        admnNumberController: _idController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        onCourseSelection: (val) {
                          _selectedCourse = val;
                        },
                        onNext: () {
                          if (!_isAllFieldsEmpty(fieldValues: [
                            _role,
                            _selectedCourse,
                            _firstNameController.text,
                            _lastNameController.text,
                            _idController.text,
                            _emailController.text,
                            _phoneController.text
                          ])) {
                            setState(() {
                              formNumber++;
                            });
                          }
                        })
                    : formNumber == 2
                        ? _personalDetailForm(
                            isStudent: isStudentRegistration,
                            size: size,
                            coController: _coNameController,
                            coPhoneController: _coPhoneController,
                            dobController: _dobController,
                            genderValueController: _genderController,
                            admnDateController: _joiningDateController,
                            batchController: _batchNameController,
                            onNext: () {
                              if (!_isAllFieldsEmpty(fieldValues: [
                                _coNameController.text,
                                _coPhoneController.text,
                                _dobController.text,
                                _genderController.text,
                                _joiningDateController.text,
                                isStudentRegistration
                                    ? _batchNameController.text
                                    : "Faculty"
                              ])) {
                                setState(() {
                                  formNumber++;
                                });
                              }
                            },
                            onPrev: () {
                              setState(() {
                                formNumber--;
                              });
                            })
                        : otherDetailForm2(
                            isStudent: isStudentRegistration,
                            size: size,
                            addressController: _addressController,
                            bachelorsController: _bachelorsController,
                            plusTwoController: _plusTwoController,
                            sslcController: _sslcController,
                            onSignup: () {
                              // Create a Faculty or Student object based on the role
                              if (isStudentRegistration) {
                                // Create a Student object
                                Student student = Student(
                                  loginPassword: password,
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  studentId: _idController.text,
                                  course: _selectedCourse,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  joiningDate: _joiningDateController.text,
                                  batch: _batchNameController.text,
                                  dob: _dobController.text,
                                  gender: _genderController.text,
                                  guardianName: _coNameController.text,
                                  guardianPhone: _coPhoneController.text,
                                  address: _addressController.text,
                                  sslc: _sslcController.text,
                                  plusTwo: _plusTwoController.text,
                                  bachelors: _bachelorsController.text,
                                );

                                // Call signupUser for a student
                                model.signupUser(
                                  isStudent: true,
                                  student: student,
                                  faculty: null, // Pass null for faculty
                                );
                              } else {
                                // Create a Faculty object
                                Faculty faculty = Faculty(
                                  loginPassword: password,
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  employeeId: _idController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  joiningDate: _joiningDateController.text,
                                  subject: _batchNameController.text,
                                  dob: _dobController.text,
                                  gender: _genderController.text,
                                  coName: _coNameController.text,
                                  coPhoneNumber: _coPhoneController.text,
                                  address: _addressController.text,
                                  course: _selectedCourse,
                                );

                                // Call signupUser for a faculty
                                model.signupUser(
                                  isStudent: false,
                                  faculty: faculty,
                                  student: null, // Pass null for student
                                );
                              }
                            },
                            onPrev: () {
                              setState(() {
                                formNumber--;
                              });
                            }),
              ],
            ),
          ),
        ));
      },
    );
  }

  Widget basicDetailForm({
    String? selectedCourse,
    String? selectedRole,
    required Size size,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController admnNumberController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required Function(String) onCourseSelection,
    required Function onNext,
    required Function(String) onRoleSelection,
  }) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        CustomTextField(
          textEditingController: firstNameController,
          labelText: "First name",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomTextField(
          textEditingController: lastNameController,
          labelText: "Last name",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomDropdown(
          selectedValue: selectedRole,
          labelText: "Chose role",
          items: const ["Student", "Faculty"],
          onChanged: (val) {
            onRoleSelection(val);
          },
          width: size.width * 0.85,
          height: size.height * 0.08,
        ),
        CustomTextField(
          textEditingController: admnNumberController,
          labelText: "Admn/Roll No/Employee Id",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomDropdown(
          selectedValue: selectedCourse,
          labelText: "Select course",
          items: const ["MCA", "MBA"],
          onChanged: (val) {
            onRoleSelection(val);
          },
          width: size.width * 0.85,
          height: size.height * 0.08,
        ),
        CustomTextField(
          textEditingController: phoneController,
          labelText: "Phone",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomTextField(
          textEditingController: emailController,
          labelText: "Email",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width * 0.6),
          child: CustomButton(
              label: "Next",
              onPressed: () {
                onNext();
              },
              width: size.width * 0.25,
              height: size.height * 0.04),
        )
      ],
    );
  }

  Widget _personalDetailForm(
      {required Size size,
      required TextEditingController coController,
      required TextEditingController coPhoneController,
      required TextEditingController genderValueController,
      required TextEditingController dobController,
      required TextEditingController admnDateController,
      required TextEditingController batchController,
      required Function onNext,
      required Function onPrev,
      required bool isStudent}) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        CustomTextField(
          textEditingController: admnDateController,
          labelText: isStudent ? "Admission date" : "Joining date",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomTextField(
          textEditingController: batchController,
          labelText: isStudent ? "Batch" : "Subject",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomDatePicker(
          dateController: dobController,
          labelText: "DoB",
          width: size.width * 0.85,
          height: size.height * 0.08,
        ),
        CustomDropdown(
          labelText: "Gender",
          items: const ["Male", "Female"],
          onChanged: (val) {
            genderValueController.text = val;
          },
          width: size.width * 0.85,
          height: size.height * 0.08,
        ),
        CustomTextField(
          textEditingController: coController,
          labelText: isStudent ? "Guardian name" : "C/O",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        CustomTextField(
          textEditingController: coPhoneController,
          labelText: isStudent ? "Guardian phone" : "C/O phone number",
          width: size.width * 0.85,
          height: size.height * 0.08,
          isPassword: false,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
                label: "Prev",
                onPressed: () {
                  onPrev();
                },
                width: size.width * 0.25,
                height: size.height * 0.04),
            CustomButton(
                label: "Next",
                onPressed: () {
                  onNext();
                },
                width: size.width * 0.25,
                height: size.height * 0.04),
          ],
        )
      ],
    );
  }

  Widget otherDetailForm2(
      {required Size size,
      required TextEditingController addressController,
      required TextEditingController sslcController,
      required TextEditingController plusTwoController,
      required TextEditingController bachelorsController,
      required Function onPrev,
      required bool isStudent,
      required Function onSignup}) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        CustomTextField(
          textEditingController: addressController,
          labelText: "Address",
          width: size.width * 0.85,
          height: size.height * 0.15,
          isPassword: false,
        ),
        Visibility(
          visible: isStudent,
          child: Column(
            children: [
              CustomTextField(
                textEditingController: sslcController,
                labelText: "SSLC",
                width: size.width * 0.85,
                height: size.height * 0.08,
                isPassword: false,
              ),
              CustomTextField(
                textEditingController: plusTwoController,
                labelText: "Plus two",
                width: size.width * 0.85,
                height: size.height * 0.08,
                isPassword: false,
              ),
              CustomTextField(
                textEditingController: plusTwoController,
                labelText: "Bachelors",
                width: size.width * 0.85,
                height: size.height * 0.08,
                isPassword: false,
              ),
            ],
          ),
        ),
        CustomTextField(
            labelText: "Password",
            width: size.width * 0.85,
            height: size.height * 0.08,
            isPassword: true,
            textEditingController: _passwordController),
        CustomTextField(
            labelText: "Confirm password",
            width: size.width * 0.85,
            height: size.height * 0.08,
            isPassword: true,
            textEditingController: _confirmPasswordController),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
                label: "Prev",
                onPressed: () {
                  onPrev();
                },
                width: size.width * 0.25,
                height: size.height * 0.04),
            CustomButton(
                label: "Signup",
                onPressed: () {
                  // Check if passwords match
                  bool isMatchingPassword = _passwordController.text ==
                      _confirmPasswordController.text;

                  // Collect all form field values
                  List<String> formFieldValues = [
                    _passwordController.text,
                    _confirmPasswordController.text,
                    _addressController.text
                  ];

                  // Add additional fields if it's a student registration
                  if (isStudentRegistration) {
                    formFieldValues.addAll([
                      _sslcController.text,
                      _bachelorsController.text,
                      _plusTwoController.text
                    ]);
                  }

                  // Check if all fields are filled
                  bool areAllFieldsFilled =
                      !_isAllFieldsEmpty(fieldValues: formFieldValues);

                  // Perform validation
                  if (!isMatchingPassword) {
                    print("Passwords do not match");
                  } else if (!areAllFieldsFilled) {
                    print("Fields cannot be empty");
                  } else {
                    // If passwords match and all fields are filled, proceed with signup
                    onSignup();
                  }
                },
                width: size.width * 0.25,
                height: size.height * 0.04),
          ],
        )
      ],
    );
  }
}
