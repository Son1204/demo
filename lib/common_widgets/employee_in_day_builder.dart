import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:test123/models/chi_tiet_ky_cong.dart';
import 'package:test123/models/employee.dart';
import 'package:test123/models/ky_cong.dart';

import '../pages/employee_form_page.dart';
import '../services/database_service.dart';
import 'employee_detail_builder.dart';
// import 'package:material_dialogs/material_dialogs.dart';

class EmployeeInDayBuilder extends StatefulWidget {
  const EmployeeInDayBuilder({Key? key, required this.dateTime})
      : super(key: key);
  final DateTime dateTime;

  @override
  _EmployeeInDayBuilder createState() => _EmployeeInDayBuilder();
}

class _EmployeeInDayBuilder extends State<EmployeeInDayBuilder> {
  final DatabaseService _databaseService = DatabaseService();
  int soNVLamCaNgay = 0;
  int soNVLamBuoiSang = 0;
  int soNVLamBuoiChieu = 0;
  int soNVNghi = 0;
  int totalWageOfDay = 0;
  bool isLoaded = false;
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));

  Future<List<Employee>> _getEmployee() async {
    return await _databaseService.findAllEmployees();
  }

  Future<List<ChiTietKyCong>> _getChiTietKyCongByDateTime() async {
    return await _databaseService.findChiTietKyCongByDateTime(widget.dateTime);
  }

  @override
  void initState() {
    super.initState();
    print("INIT STATE: " + widget.dateTime.toString());
    // print(isSameDay(widget.dateTime));
  }

  // bool isSameDay(DateTime dateTime) {
  //   var dateNow = DateTime.now();
  //   if (dateNow.day == dateTime.day &&
  //       dateNow.month == dateTime.month &&
  //       dateNow.year == dateTime.year) {
  //     return true;
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    // if (isLoaded == false) {
    //
    // }
    _getChiTietKyCongByDateTime().then((value) {
      soNVLamCaNgay = 0;
      soNVLamBuoiSang = 0;
      soNVLamBuoiChieu = 0;
      soNVNghi = 0;
      totalWageOfDay = 0;

      for (var element in value) {
        print('Load summary day:' + element.chamCongNgay.toString());
        soNVLamCaNgay += element.chamCongNgay[0];
        soNVLamBuoiSang += element.chamCongNgay[1];
        soNVLamBuoiChieu += element.chamCongNgay[2];
        soNVNghi += element.chamCongNgay[3];

        // Tinh tong so tien can tra theo ngay
        totalWageOfDay += element.thuNhapThucTe;
      }
      print("CẢ NGAY SO NV: " + soNVLamCaNgay.toString());
      isLoaded = true;
    });
    print('_EmployeeInDayBuilder');
    return FutureBuilder<List<Employee>>(
      future: _getEmployee(),
      initialData: const [],
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "TỔNG LƯƠNG NGÀY " +
                                  DateFormat('dd/MM').format(widget.dateTime) +
                                  ": ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const FaIcon(FontAwesomeIcons.paypal),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                _formatNumber(totalWageOfDay.toString()) +
                                    ' VNĐ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.redAccent,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.all(10),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Cả ngày: ' + soNVLamCaNgay.toString(),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Buổi sáng: ' + soNVLamBuoiSang.toString(),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Buổi chiều: ' + soNVLamBuoiChieu.toString(),
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Nghỉ: ' + soNVNghi.toString(),
                              style: const TextStyle(
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Danh sách nhân viên',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        // isLoaded = false;
                        setState(() {});
                        // snapshot.data?.forEach((element) async {
                        //   await _databaseService.updateEmployee(element);
                        // });
                        // Dialogs.materialDialog(
                        //   msg: 'Are you sure ? you can\'t undo this',
                        //   title: "Delete",
                        //   color: Colors.white,
                        //   context: context,
                        //   actions: [
                        //     TextButton(onPressed: () {}, child: Text("OK")),
                        //   ],
                        // );
                      },
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final employee = snapshot.data![index];
                  return BuildEmployeeCard(
                    employee: employee,
                    dateTime: widget.dateTime,
                    onReload: () {
                      setState(() {});
                    },
                    needLoad: false,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class BuildEmployeeCard extends StatefulWidget {
  const BuildEmployeeCard({
    Key? key,
    required this.employee,
    required this.onReload,
    required this.dateTime,
    required this.needLoad,
  }) : super(key: key);
  final Function() onReload;
  final DateTime dateTime;
  final Employee employee;
  final bool needLoad;
  final bool isActiveBtn11 = false;
  final bool isActiveBtn22 = false;
  final bool isActiveBtn33 = false;
  final bool isActiveBtn44 = false;

  @override
  _BuildEmployeeCard createState() => _BuildEmployeeCard();
}

class _BuildEmployeeCard extends State<BuildEmployeeCard> {
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi').format(int.parse(s));
  bool isActiveBtn1 = false;
  bool isActiveBtn2 = false;
  bool isActiveBtn3 = false;
  bool isActiveBtn4 = false;
  var preDateTime = DateTime(1998, 12, 04);

  final DatabaseService _databaseService = DatabaseService();
  late ChiTietKyCong _chiTietKyCong = ChiTietKyCong(
    title: "title",
    kyCongId: 0,
    date: DateFormat('yyyyMMdd').format(widget.dateTime),
    day: widget.dateTime.day,
    chamCongNgay: [0, 0, 0, 0],
    thuNhapThucTe: 0,
  );

  Future<ChiTietKyCong> _createIfNotExistsKyCong() async {
    var exists = await _databaseService.checkKyCongId(
      widget.employee.id!,
      widget.dateTime,
    );
    var kyCongId = 0;
    if (!exists) {
      kyCongId = await _databaseService.insertKyCong(
        KyCong(
          title: "kycong",
          month: widget.dateTime.month,
          year: widget.dateTime.year,
          employeeId: widget.employee.id!,
        ),
      );
      await _databaseService.insertChiTietKyCong(
        ChiTietKyCong(
          title: "detail",
          kyCongId: kyCongId,
          day: widget.dateTime.day,
          chamCongNgay: [0, 0, 0, 0],
          thuNhapThucTe: 0,
          date: DateFormat('yyyyMMdd').format(widget.dateTime),
        ),
      );
    }

    var existsChiTietKyCong = await _databaseService.checkChiTietKyCong(
      widget.employee.id!,
      widget.dateTime,
    );
    if (!existsChiTietKyCong) {
      if (kyCongId == 0) {
        var kyCong = await _databaseService.findKyCongIdByEmployeeAndDateTime(
          widget.employee.id!,
          widget.dateTime,
        );
        kyCongId = kyCong.id!;
      }
      await _databaseService.insertChiTietKyCong(
        ChiTietKyCong(
          title: "detail",
          kyCongId: kyCongId,
          day: widget.dateTime.day,
          chamCongNgay: [0, 0, 0, 0],
          thuNhapThucTe: 0,
          date: DateFormat('yyyyMMdd').format(widget.dateTime),
        ),
      );
    }

    print('(_createIfNotExistsKyCong)existed');
    return await _databaseService.findChiTietKyCongByEmployeeIdAndDateTime(
      widget.employee.id!,
      widget.dateTime,
    );
  }

  @override
  void initState() {
    super.initState();
    print("INIT _BuildEmployeeCard");
  }

  bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime2.day == dateTime1.day &&
        dateTime2.month == dateTime1.month &&
        dateTime2.year == dateTime1.year) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!isSameDay(preDateTime, widget.dateTime)) {
      _createIfNotExistsKyCong().then((value) {
        _chiTietKyCong = value;
        isActiveBtn1 = _chiTietKyCong.chamCongNgay[0] == 1 ? true : false;
        isActiveBtn2 = _chiTietKyCong.chamCongNgay[1] == 1 ? true : false;
        isActiveBtn3 = _chiTietKyCong.chamCongNgay[2] == 1 ? true : false;
        isActiveBtn4 = _chiTietKyCong.chamCongNgay[3] == 1 ? true : false;
        print(value);
        setState(() {});
      });

      print("BUILD _BuildEmployeeCard, " + preDateTime.toString());
      preDateTime = widget.dateTime;
      print("BUILD _BuildEmployeeCard, " + widget.dateTime.toString());
    }

    print('EMPLOYEE_ID: ' + widget.employee.id.toString());
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EmployeeDetailBuilder(employee: widget.employee),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                },
                child: Text(
                  widget.employee.name,
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.only(bottom: 5),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Lương ngày hôm nay: '),
                      Text(
                        _formatNumber(
                              _chiTietKyCong.thuNhapThucTe.toString(),
                            ) +
                            ' đ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Lương/Ngày: " +
                          _formatNumber(
                            int.parse(widget.employee.dateUpLevel) <=
                                    int.parse(DateFormat('yyyyMMdd')
                                        .format(widget.dateTime))
                                ? widget.employee.wage.toString()
                                : widget.employee.wageOld.toString(),
                          ) +
                          ' đ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isActiveBtn1 ? Colors.blue : Colors.white,
                      ),
                    ),
                    child: Text(
                      'Cả ngày',
                      style: TextStyle(
                        color: isActiveBtn1 ? Colors.white : Colors.black,
                      ),
                    ),
                    onPressed: () => setState(() {
                      isActiveBtn1 = true;
                      isActiveBtn2 = false;
                      isActiveBtn3 = false;
                      isActiveBtn4 = false;

                      _chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                      _chiTietKyCong.chamCongNgay[0] = 1;
                      print(
                          'CẢ NGÀY: ' + _chiTietKyCong.chamCongNgay.toString());
                      var preThuNhapThucTe = _chiTietKyCong.thuNhapThucTe;
                      _chiTietKyCong.thuNhapThucTe = 0;

                      if (int.parse(widget.employee.dateUpLevel) >=
                          int.parse(
                              DateFormat('yyyyMMdd').format(DateTime.now()))) {
                        _chiTietKyCong.thuNhapThucTe = widget.employee.wage;
                      } else {
                        _chiTietKyCong.thuNhapThucTe = widget.employee.wageOld;
                      }

                      if (preThuNhapThucTe < _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapCongThem =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapCongThem;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapCongThem;
                      }

                      if (preThuNhapThucTe > _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapGiamBot =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapGiamBot;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapGiamBot;
                      }
                      _databaseService.updateEmployee(widget.employee);
                      _databaseService.updateChiTietKyCong(_chiTietKyCong);
                      widget.onReload();
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isActiveBtn2 ? Colors.blue : Colors.white,
                      ),
                    ),
                    child: Text(
                      'Buổi sáng',
                      style: TextStyle(
                        color: isActiveBtn2 ? Colors.white : Colors.black,
                      ),
                    ),
                    onPressed: () => setState(() {
                      isActiveBtn2 = true;
                      isActiveBtn1 = false;
                      isActiveBtn3 = false;
                      isActiveBtn4 = false;

                      _chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                      _chiTietKyCong.chamCongNgay[1] = 1;
                      var preThuNhapThucTe = _chiTietKyCong.thuNhapThucTe;

                      _chiTietKyCong.thuNhapThucTe = 0;

                      if (int.parse(widget.employee.dateUpLevel) >=
                          int.parse(
                              DateFormat('yyyyMMdd').format(DateTime.now()))) {
                        _chiTietKyCong.thuNhapThucTe =
                            (widget.employee.wage / 2).round();
                      } else {
                        _chiTietKyCong.thuNhapThucTe =
                            (widget.employee.wageOld / 2).round();
                      }

                      if (preThuNhapThucTe < _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapCongThem =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapCongThem;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapCongThem;
                      }

                      if (preThuNhapThucTe > _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapGiamBot =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapGiamBot;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapGiamBot;
                      }

                      _databaseService.updateEmployee(widget.employee);
                      _databaseService.updateChiTietKyCong(_chiTietKyCong);

                      print('BUỔI SÁNG: ' +
                          _chiTietKyCong.chamCongNgay.toString());
                      widget.onReload();
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isActiveBtn3 ? Colors.blue : Colors.white,
                      ),
                    ),
                    child: Text(
                      'Buổi chiều',
                      style: TextStyle(
                        color: isActiveBtn3 ? Colors.white : Colors.black,
                      ),
                    ),
                    onPressed: () => setState(() {
                      isActiveBtn3 = true;
                      isActiveBtn1 = false;
                      isActiveBtn2 = false;
                      isActiveBtn4 = false;

                      _chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                      _chiTietKyCong.chamCongNgay[2] = 1;
                      var preThuNhapThucTe = _chiTietKyCong.thuNhapThucTe;

                      _chiTietKyCong.thuNhapThucTe = 0;
                      if (int.parse(widget.employee.dateUpLevel) >=
                          int.parse(
                              DateFormat('yyyyMMdd').format(DateTime.now()))) {
                        _chiTietKyCong.thuNhapThucTe =
                            (widget.employee.wage / 2).round();
                      } else {
                        _chiTietKyCong.thuNhapThucTe =
                            (widget.employee.wageOld / 2).round();
                      }

                      if (preThuNhapThucTe < _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapCongThem =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapCongThem;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapCongThem;
                      }

                      if (preThuNhapThucTe > _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapGiamBot =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapGiamBot;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapGiamBot;
                      }

                      _databaseService.updateEmployee(widget.employee);
                      _databaseService.updateChiTietKyCong(_chiTietKyCong);
                      widget.onReload();
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isActiveBtn4 ? Colors.blue : Colors.white,
                      ),
                    ),
                    child: Text(
                      'Nghỉ',
                      style: TextStyle(
                        color: isActiveBtn4 ? Colors.white : Colors.black,
                      ),
                    ),
                    onPressed: () => setState(() {
                      isActiveBtn4 = true;
                      isActiveBtn1 = false;
                      isActiveBtn2 = false;
                      isActiveBtn3 = false;

                      _chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                      _chiTietKyCong.chamCongNgay[3] = 1;

                      var preThuNhapThucTe = _chiTietKyCong.thuNhapThucTe;
                      _chiTietKyCong.thuNhapThucTe = 0;

                      if (preThuNhapThucTe < _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapCongThem =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapCongThem;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapCongThem;
                      }

                      if (preThuNhapThucTe > _chiTietKyCong.thuNhapThucTe) {
                        var thuNhapGiamBot =
                            _chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                        widget.employee.chuaThanhToan =
                            widget.employee.chuaThanhToan + thuNhapGiamBot;
                        widget.employee.tongTienChuaThanhToan =
                            widget.employee.tongTienChuaThanhToan +
                                thuNhapGiamBot;
                      }

                      _databaseService.updateEmployee(widget.employee);
                      _databaseService.updateChiTietKyCong(_chiTietKyCong);

                      print('NGHỈ: ' + _chiTietKyCong.chamCongNgay.toString());
                      widget.onReload();
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
