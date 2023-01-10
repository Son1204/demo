import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test123/models/chi_tiet_ky_cong.dart';
import 'package:test123/models/employee.dart';
import '../services/database_service.dart';

class EmployeeWageBuilder extends StatefulWidget {
  const EmployeeWageBuilder({Key? key, required this.employee, required this.selectedDate, required this.onReload})
      : super(key: key);
  final Employee employee;
  final DateTime selectedDate;
  final Function onReload;

  @override
  _EmployeeWageBuilder createState() => _EmployeeWageBuilder();
}

class _EmployeeWageBuilder extends State<EmployeeWageBuilder> {
  int soNVLamCaNgay = 0;
  int soNVLamBuoiSang = 0;
  int soNVLamBuoiChieu = 0;
  int soNVNghi = 0;
  int totalWage = 0;
  double tongCongTrongThang = 0;

  final DatabaseService _databaseService = DatabaseService();

  Future<List<ChiTietKyCong>> _getChiTietKyCongByEmployeeAndDate() async {
    return await _databaseService.findChiTietKyCongByEmployeeAndDate(
        widget.employee.id!, widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    String _formatNumber(String s) =>
        NumberFormat.decimalPattern('vi').format(int.parse(s));
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhân viên: ' + widget.employee.name),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ChiTietKyCong>>(
          future: _getChiTietKyCongByEmployeeAndDate(),
          initialData: const [],
          builder: (context, snapshot) {
            soNVLamCaNgay = 0;
            soNVLamBuoiSang = 0;
            soNVLamBuoiChieu = 0;
            soNVNghi = 0;
            totalWage = 0;
            tongCongTrongThang = 0;

            snapshot.data?.forEach((element) {
              soNVLamCaNgay += element.chamCongNgay[0];
              soNVLamBuoiSang += element.chamCongNgay[1];
              soNVLamBuoiChieu += element.chamCongNgay[2];
              soNVNghi += element.chamCongNgay[3];

              if (element.chamCongNgay[0] == 1) {
                tongCongTrongThang += 1;
              }

              if (element.chamCongNgay[1] == 1 ||
                  element.chamCongNgay[2] == 1) {
                tongCongTrongThang += 0.5;
              }

              // Tinh tong so tien can tra theo ngay
              totalWage += element.thuNhapThucTe;
            });
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Chưa có dữ liệu", style: TextStyle(fontSize: 21,),),
              );
            }
            return Container(
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Lương tháng '+DateFormat("MM/yyyy").format(widget.selectedDate)+': ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatNumber(totalWage.toString()) + ' VNĐ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Lương/Ngày: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatNumber(widget.employee.wage.toString()) +
                              ' VNĐ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Tổng số công trong tháng '+DateFormat("MM/yyyy").format(widget.selectedDate)+': ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          tongCongTrongThang.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(5)),
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
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(5)),
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
                            vertical: 10, horizontal: 15),
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
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Nghỉ: ' + soNVNghi.toString(),
                          style:
                              const TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final chiTietKyCong = snapshot.data![index];
                        return BuildChiTietKyCongCard(
                          chiTietKyCong: chiTietKyCong,
                          employee: widget.employee,
                          onReload: () {
                            setState(() {});
                          },
                          selectedDate: widget.selectedDate,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
     super.dispose();
     widget.onReload();
  }
}

class BuildChiTietKyCongCard extends StatefulWidget {
  const BuildChiTietKyCongCard({
    Key? key,
    required this.chiTietKyCong,
    required this.employee,
    required this.onReload, required this.selectedDate,
  }) : super(key: key);
  final ChiTietKyCong chiTietKyCong;
  final Employee employee;
  final Function() onReload;
  final DateTime selectedDate;

  @override
  _BuildChiTietKyCongCard createState() => _BuildChiTietKyCongCard();
}

class _BuildChiTietKyCongCard extends State<BuildChiTietKyCongCard> {
  late bool isActiveBtn1 =
      widget.chiTietKyCong.chamCongNgay[0] == 1 ? true : false;
  late bool isActiveBtn2 =
      widget.chiTietKyCong.chamCongNgay[1] == 1 ? true : false;
  late bool isActiveBtn3 =
      widget.chiTietKyCong.chamCongNgay[2] == 1 ? true : false;
  late bool isActiveBtn4 =
      widget.chiTietKyCong.chamCongNgay[3] == 1 ? true : false;
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ngày ' +
                    DateFormat('dd/MM').format(DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.chiTietKyCong.day,
                    )) +
                    ': ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isActiveBtn1 ? Colors.blue : Colors.white),
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

                  widget.chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                  widget.chiTietKyCong.chamCongNgay[0] = 1;
                  print('CẢ NGÀY: ' +
                      widget.chiTietKyCong.chamCongNgay.toString());
                  var preThuNhapThucTe = widget.chiTietKyCong.thuNhapThucTe;
                  widget.chiTietKyCong.thuNhapThucTe = 0;

                  if (int.parse(widget.employee.dateUpLevel) <=
                      int.parse(
                          DateFormat('yyyyMMdd').format(DateTime(
                            widget.selectedDate.year,
                            widget.selectedDate.month,
                            widget.chiTietKyCong.day,
                          )))) {
                    widget.chiTietKyCong.thuNhapThucTe = widget.employee.wage;
                  } else {
                    widget.chiTietKyCong.thuNhapThucTe = widget.employee.wageOld;
                  }

                  if (preThuNhapThucTe < widget.chiTietKyCong.thuNhapThucTe) {
                    var thuNhapCongThem =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapCongThem;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapCongThem;
                  }

                  if (preThuNhapThucTe > widget.chiTietKyCong.thuNhapThucTe) {
                    var thuNhapGiamBot =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapGiamBot;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapGiamBot;
                  }

                  _databaseService.updateEmployee(widget.employee);
                  _databaseService.updateChiTietKyCong(widget.chiTietKyCong);
                  widget.onReload();
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isActiveBtn2 ? Colors.green : Colors.white,
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
                  widget.chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                  widget.chiTietKyCong.chamCongNgay[1] = 1;

                  var preThuNhapThucTe = widget.chiTietKyCong.thuNhapThucTe;

                  widget.chiTietKyCong.thuNhapThucTe = 0;

                  if (int.parse(widget.employee.dateUpLevel) <=
                      int.parse(
                          DateFormat('yyyyMMdd').format(DateTime(
                            widget.selectedDate.year,
                            widget.selectedDate.month,
                            widget.chiTietKyCong.day,
                          )))) {
                    widget.chiTietKyCong.thuNhapThucTe =
                        (widget.employee.wage / 2).round();
                  } else {
                    widget.chiTietKyCong.thuNhapThucTe =
                        (widget.employee.wageOld / 2).round();
                  }

                  if (preThuNhapThucTe < widget.chiTietKyCong.thuNhapThucTe) {
                    var thuNhapCongThem =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapCongThem;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapCongThem;
                  }

                  if (preThuNhapThucTe > widget.chiTietKyCong.thuNhapThucTe) {
                    var thuNhapGiamBot =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapGiamBot;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapGiamBot;
                  }

                  _databaseService.updateEmployee(widget.employee);
                  _databaseService.updateChiTietKyCong(widget.chiTietKyCong);

                  print('BUỔI SÁNG: ' +
                      widget.chiTietKyCong.chamCongNgay.toString());
                  widget.onReload();
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  isActiveBtn3 ? Colors.orange : Colors.white,
                )),
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
                  widget.chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                  widget.chiTietKyCong.chamCongNgay[2] = 1;

                  var preThuNhapThucTe = widget.chiTietKyCong.thuNhapThucTe;

                  widget.chiTietKyCong.thuNhapThucTe = 0;

                  if (int.parse(widget.employee.dateUpLevel) <=
                      int.parse(
                          DateFormat('yyyyMMdd').format(DateTime(
                            widget.selectedDate.year,
                            widget.selectedDate.month,
                            widget.chiTietKyCong.day,
                          )))) {
                    widget.chiTietKyCong.thuNhapThucTe =
                        (widget.employee.wage / 2).round();
                  } else {
                    widget.chiTietKyCong.thuNhapThucTe =
                        (widget.employee.wageOld / 2).round();
                  }

                  if (preThuNhapThucTe < widget.chiTietKyCong.thuNhapThucTe) {
                    var thuNhapCongThem =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapCongThem;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapCongThem;
                  }

                  if (preThuNhapThucTe > widget.chiTietKyCong.thuNhapThucTe) {
                    var thuNhapGiamBot =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapGiamBot;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapGiamBot;
                  }

                  _databaseService.updateEmployee(widget.employee);
                  _databaseService.updateChiTietKyCong(widget.chiTietKyCong);

                  print('BUỔI CHIỀU: ' +
                      widget.chiTietKyCong.chamCongNgay.toString());
                  widget.onReload();
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isActiveBtn4 ? Colors.deepOrangeAccent : Colors.white,
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
                  widget.chiTietKyCong.chamCongNgay = [0, 0, 0, 0];
                  widget.chiTietKyCong.chamCongNgay[3] = 1;

                  var preThuNhapThucTe = widget.chiTietKyCong.thuNhapThucTe;
                  widget.chiTietKyCong.thuNhapThucTe = 0;

                    var thuNhapGiamBot =
                        widget.chiTietKyCong.thuNhapThucTe - preThuNhapThucTe;
                    widget.employee.chuaThanhToan =
                        widget.employee.chuaThanhToan + thuNhapGiamBot;
                    widget.employee.tongTienChuaThanhToan =
                        widget.employee.tongTienChuaThanhToan +
                            thuNhapGiamBot;

                  _databaseService.updateEmployee(widget.employee);
                  _databaseService.updateChiTietKyCong(widget.chiTietKyCong);

                  print('NGHỈ: ' + widget.chiTietKyCong.chamCongNgay.toString());
                  widget.onReload();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
