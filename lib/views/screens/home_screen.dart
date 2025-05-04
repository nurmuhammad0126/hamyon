import 'package:flutter/material.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:hammyon/views/widgets/month_details.dart';
import 'package:hammyon/views/widgets/month_dialog.dart';
import 'package:hammyon/views/widgets/my_dialog.dart';
import 'package:hammyon/views/widgets/plan_indicator.dart';
import 'package:hammyon/views/widgets/search_delegate.dart';
import 'package:hammyon/views/widgets/total_price.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final planController = TextEditingController();
  late final MyViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = context.read<MyViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    print("\x1B[31mHOME BUILD ISHLADI\x1B[0m");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            viewModel.filterMonth(where: false);
          },
          icon: Icon(Icons.chevron_left),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<MyViewModel>(
              builder: (_, value, __) {
                return Text(
                  value.month <= 9
                      ? "0${value.month} . ${value.year}"
                      : "${value.month} . ${value.year}",
                );
              },
            ),

            IconButton(
              onPressed: () async {
                viewModel.getNotes(month: viewModel.month);
                await showSearch(
                  context: context,
                  delegate: SearchViewDelegate(viewModel.notes),
                );
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.filterMonth(where: true);
            },
            icon: Icon(Icons.chevron_right),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TotalPrice(),
              SizedBox(height: 60),
              Consumer<MyViewModel>(
                builder: (_, value, __) {
                  return PlanIndicator(
                    pracent: value.pracent,
                    planSumm: value.newPlanAmount,
                    alert: MonthDialog(
                      planController: planController,
                      planSumm: value.planSumm,
                      month: value.month,
                      year: value.year,
                      refrash: () {
                        value.getNotes(month: viewModel.month);
                        value.refrash();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Consumer<MyViewModel>(
                builder: (_,value,__) {
                  return MonthDetails();
                }
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await showDialog(
            context: context,
            builder: (context) {
              return MyDialog();
            },
          );
          if (res == true) {
            viewModel.refrash();
          }
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
