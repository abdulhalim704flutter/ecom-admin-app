import 'package:ecom_admin/models/dashboard_item.dart';
import 'package:flutter/material.dart';

class DashboardItemView extends StatelessWidget {
  final DashboardItem item;
  const DashboardItemView({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, item.route),
        child: Card(
          color: Colors.lightBlueAccent.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon,size: 40.0,color: Colors.white,),
                SizedBox(height: 15,),
                Text(item.name,style: TextStyle(fontSize: 18,color: Colors.white),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
