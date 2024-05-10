import 'package:flutter/material.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/on_board_model/on_board_model.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../login&register_screen/account_screen/account_screen.dart';

class on_boarding extends StatefulWidget{
  @override
  State<on_boarding> createState() => _on_boardingState();
}
class _on_boardingState extends State<on_boarding> {
  var boardController=PageController();
  bool isLast=false;
  void submit(){
    CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if(value)
      {
        navigateAndFinish(context, account_screen()
        );
      }
    });
  }
  List<onBoardingModel> boarding=[
    onBoardingModel(
        image: ('images/onboard1.png'),
        tittle: 'Screen tittle 1',
        description: 'Description 1'
    ),
    onBoardingModel(
        image: ('images/onboard2.png'),
        tittle: 'Screen tittle 2',
        description: 'Description 2'
    ),
    onBoardingModel(
        image: ('images/onboard3.png'),
        tittle: 'Screen tittle 3',
        description: 'Description 3'
    )
  ];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
         actions: [
           TextButton(onPressed: (){
             submit();
           },
               child: Text('SKIP',style: TextStyle(color: firstColor),))
         ],
       ),
       body:
       Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           children: [
             Expanded(
               child: PageView.builder(
                 onPageChanged: (index){
                   if(index==boarding.length-1){
                     setState(() {
                       isLast=true;
                     });
                   }
                   else {
                     setState(() {
                       isLast=false;
                     });
                   }
                 },
                 controller: boardController,
                 physics: BouncingScrollPhysics(),
                 itemBuilder:(context,index)=> buildBoardingItem(boarding[index]),
                 itemCount: boarding.length,),
             ),
             Row(
               children: [
                 SmoothPageIndicator(
                     effect:ExpandingDotsEffect(
                         dotColor: secondColor,
                         activeDotColor: firstColor,
                         dotWidth: 10,
                         dotHeight: 10,
                         expansionFactor: 4,
                         radius: 10,
                         spacing: 5
                     ) ,
                     controller: boardController,
                     count: boarding.length),
                 Spacer(),
                 FloatingActionButton(
                   shape: CircleBorder(),
                   backgroundColor: firstColor,
                   elevation: 0,
                   onPressed: (){
                     if(isLast) {
                     submit();
                   }else{
                     boardController.nextPage(duration: Duration(milliseconds: 750), curve:Curves.fastEaseInToSlowEaseOut );
                   };
                   },
                   child: Icon(Icons.keyboard_arrow_right_sharp,color: forthColor,),)
               ],
             )
           ],
         ),
       )
   );
  }
  Widget buildBoardingItem(onBoardingModel onboard)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${onboard.image}'),
        ),
      ),
      Text('${onboard.tittle}',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold),),
      SizedBox(height: 40,),
      Text('${onboard.description}',style: TextStyle(fontSize: 20),),
      SizedBox(height: 30,),
    ],
  );
}
