import 'package:flutter/material.dart';
import 'package:sudoku_solver/sudoku.dart';

void main() {
  runApp(MyApp());
}





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isSolved=false;
  bool _toggleSolution=false;
  SudokuData _solution;
  SudokuData _inputData;
  bool _correctInput=false;
  List<bool> _buttonOption=List();
  bool _isSolving=false;
  double _timeTaken=0;


  void initState(){
    _inputData=SudokuData();
    _solution=SudokuData();
    for(int i=0; i<10; i++) _buttonOption.add(false);
  }
  
  
  _cameraIsPressed()async{
    print('camera is pressed');
  }

  @override
  Widget build(BuildContext context) {
    Size _size=MediaQuery.of(context).size;
    return new WillPopScope(child: new Scaffold(
      appBar:AppBar(
        title: Text("Sudoku Solver"),
        actions: [
          if(!_toggleSolution) IconButton(tooltip:"RESET", icon: Icon(Icons.refresh,color: Colors.white), onPressed:(){_inputData=SudokuData(); _solution=SudokuData();  _stack=List(); for(int i=0; i<10; i++) _buttonOption.add(false);
              setState(() {_correctInput=false; _isSolving=false; _isSolved=false; });}),
          if(!_toggleSolution) IconButton(icon: Icon(Icons.camera,color: Colors.white,), onPressed: _cameraIsPressed,tooltip: "By Camera",),
          IconButton(tooltip:"info",icon: Icon(Icons.info,color: Colors.white,), onPressed: (){
            showDialog(context: context,builder: (BuildContext context)=>AlertDialog(
              title: Center(child: Text('Made by DIPTSOFT'),),
              content: Text("* Currently camera scanning is not activated But in next update it'll work.\n\n**For more details visit our site      \n\nhttps:www.diptsoft.com/app/sudoku_solver\n"),
            ));
          })
        ],

      ),


      body: SingleChildScrollView( 
        child: Column(children: [
          Container( 
            height: 50,
            width: _size.width,
            child: Center( 
              child:Text(_toggleSolution ? "Solution : $_timeTaken s": 'ENTER INPUT',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink),),
            ),
          ),
          _sudokuBox(_size),
          Container( 
            height: 80,
            width: _size.width,
            child: SizedBox(),
          )

        ],),
      ),
      bottomNavigationBar: _toggleSolution ? GestureDetector( 
        onTap: _goBackClicked,
        child: Container(
          height: 50,
          color: Colors.pink,
          child: Center(child: Text("Go back",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,letterSpacing: 1.0),),),
        )
      ):GestureDetector( 
        child: Container(
        height: 50,
        color: _correctInput?Colors.green[700]: Colors.pink,
        child: Center(child: Text('GET SOLUTION',style: TextStyle(color: _correctInput?Colors.green[100]: Colors.black26,fontSize: 22,fontWeight: FontWeight.bold),),),
        
      ),
      onTap: ()async{
        //solve 
        if(_correctInput && !_isSolving){
            for(int i=1; i<10; i++) for(int j=1; j<10; j++) {
              _solution.data[i][j].col=i;
              _solution.data[i][j].row=j;
              _solution.data[i][j].value=_inputData.data[i][j].value;
              if(_inputData.data[i][j].value!=0) _solution.data[i][j].isDefined=true;
            }
            _isSolved=false;
            _isSolving=true;
            _correctInput=false;
            backButtonPressed=false;
            setState(() {});
            int _startTime=DateTime.now().millisecondsSinceEpoch;
            if(_inputData.validateInput()){
                print('Start solving');
              _isSolved=solving(_inputData.getListData(), 1, 1);
              if(_isSolved){
                print('answer found');
              }
            }
             _timeTaken=(DateTime.now().millisecondsSinceEpoch-_startTime)/1000;
            _isSolving=false;
            _toggleSolution=true; 
            setState(() {
              
            });;
        }
        
      },
      ),
    ), 
    onWillPop: onBackButtonHandler);
  }



  Widget _sudokuBox(Size _size){
    if(_toggleSolution && !_isSolved) return Container( 
      height: _size.width,
      width: _size.width,
      decoration: BoxDecoration( 
        border: Border.all(color: Colors.black87)
      ),
      child: Center( child: Text("No solution found",style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold),),),
    );
    //color must be red if wrong
    SudokuData _current=_toggleSolution? _solution:_inputData;
    return Container( 
      height: _size.width,
      width: _size.width,
      child: Stack(children: [
        _gridWidget(_current, _size.width/9),
        Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children:[
            Container(color: Colors.black,height:_size.width,width: 2,),
            Container(color: Colors.black,height:_size.width,width: 2,),
            Container(color: Colors.black,height:_size.width,width: 2,),
            Container(color: Colors.black,height:_size.width,width: 2,),
          ]
        ),
        Column(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children:[
            Container(color: Colors.black,height:2,width: _size.width,),
            Container(color: Colors.black,height:2,width: _size.width,),
            Container(color: Colors.black,height:2,width: _size.width,),
            Container(color: Colors.black,height:2,width: _size.width,),
          ]
        ),
        if(_isSolving) Center(child: Container(height: 100,width: 100,child: Column(children: [
          CircularProgressIndicator(),
          Text('solving',style: TextStyle(fontSize: 20,color: Colors.pink,fontWeight:FontWeight.bold),),
        ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),),),
      ],)
    );
  }

  Widget _gridWidget(SudokuData sdk,double len){
    
    List<Widget> _colWidget=List();
    for(int col=1; col<10; col++){
      List<Widget> _rowWidget=List();
      for(int i=1; i<10; i++) _rowWidget.add(
        _smallContainer(len,sdk.data[col][i])
      );
      Widget _tempRowWidget=Row(children: _rowWidget,);
      _colWidget.add(_tempRowWidget);
    }
    return Column(children:_colWidget);


  }

  Widget _smallContainer(double len,SDT sdt){
    Color _color;
    if(_toggleSolution){_color=sdt.isDefined?Colors.blue:Colors.black;}
    else {_color=sdt.isRed?Colors.red:Colors.black;}
    return InkWell( 
      child: Container( 
        height: len,
        width: len,
        child: Center( 
          child: Text(sdt.value==0?" ":sdt.value.toString(),style: TextStyle(  
            color:_color,
            fontWeight: FontWeight.bold,
            fontSize: 20
          )),
        ),
        decoration: BoxDecoration(  
          border: Border.all(color: Colors.grey[400])
        ),
      ),
      splashColor: Colors.pink,
      onTap: ()=>_buttonPressedN(sdt, len),
      onLongPress: ()=>_buttonPressedN(sdt, len),
    );
  }

  _buttonPressedN(SDT sdt,double len)async{
    if(!_toggleSolution){
          _buttonOption=_inputData.getSuggestionS(sdt.row, sdt.col);
        _inputGived=false;
        //show dialog
        await showDialog(context: context,builder: (BuildContext context)=>AlertDialog(
              content: Container( 
                height: len*2+5,
                width: len*5,
                child: Column(  
                  children: [
                    Row(  
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _button(1,len,context),_button(2,len,context),_button(3,len,context),_button(4,len,context),_button(5,len,context)
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(  
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _button(6,len,context),_button(7,len,context),_button(8,len,context),_button(9,len,context),_button(0,len,context)
                      ],
                    )
                  ],
                ),
              )
            )
            );
        if(_tempData!=null && _inputGived) {
          _stack.add(SDT(col: sdt.col,row: sdt.row,value: _inputData.data[sdt.col][sdt.row].value,isDefined:_inputData.data[sdt.col][sdt.row].isDefined,isRed: _inputData.data[sdt.col][sdt.row].isRed));
          _inputData.data[sdt.col][sdt.row].value=_tempData;
          _correctInput= _buttonOption[_tempData];
          if(!_correctInput) _inputData.data[sdt.col][sdt.row].isRed=true;
          else _inputData.data[sdt.col][sdt.row].isRed=false;
          setState(() {});
        }
        }
  }
  

  Widget _button(int num,double len,BuildContext context){
    return InkWell(
      child:Container(
      height:len,width: len,
      child:Stack(children: [Center(child:Text(num.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
      if(!_buttonOption[num]) Icon(Icons.clear_rounded,color: Colors.red,size: len,)],),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
    ),
    onTap:(){
      if(_buttonOption[num]){
        _tempData=num;
        _inputGived=true;
      Navigator.pop(context);
      }
    },
    splashColor: Colors.pink,
    );
  }

  int _tempData;
  bool _inputGived=false;
  List<SDT> _stack=List();
  int _lastBackPressedTime=0;


  Future<bool> onBackButtonHandler()async{
    int _currentTime=DateTime.now().millisecondsSinceEpoch;
    if(_currentTime-_lastBackPressedTime<200) return true;
    if(_isSolving){_isSolving=false; backButtonPressed=true; setState(() {}); return false;}
    _lastBackPressedTime=_currentTime;
    if(_toggleSolution) {_goBackClicked(); return false;}
    if(_stack.length==0) return true;
    SDT _temp=_stack[_stack.length-1];
    _inputData.updateSDT(_temp);
    if(_stack.length==1) _stack=List();
    else  _stack.removeLast();
    setState(() {});
    return false;
  }


  _goBackClicked(){
          for(int i=1; i<10; i++) for(int j=1; j<10; j++) _inputData.data[i][j].isDefined=false;        
          setState((){
            _toggleSolution=false;
          });
        }

















        bool solving(List<List<int>> dataI,int row, int col){
    List<List<int>> inp=List();
    for(int i=0; i<dataI.length; i++){
      List<int> dd=List.from(dataI[i]);
      inp.add(dd);
    }
    List<int> pos=List();
    bool unSolved=false;
   

    
    for(int i=col ; i<10; i++) for(int j= i==col? row:1; j<10; j++){
      if(dataI[i][j]==0){
        row=j; col=i; i=10; j=10;
        unSolved=true;
      }
    }
    if(!unSolved){
      _solution.updateListData(List.from(dataI));
      return true;
    }

    //creating possibilities 
    //from row
    for(int i=1; i<10; i++){
      //check in row
      bool find=false;
      for(int j=1; j<10; j++){
        if(dataI[j][row]==i){find=true; break;}
      }
      if(!find){
        for(int j=1; j<10; j++){
          if(dataI[col][j]==i){find=true; break;}
        }
      }
      if(!find){
        int stc=_getStart(col),str=_getStart(row);
        for(int m=0; m<3; m++) for(int n=0; n<3; n++) if(dataI[m+stc][n+str]==i){m=10; n=10; find=true;}
      }
      if(!find) pos.add(i);
    }


    for(int i=0; i<pos.length; i++){
      inp[col][row]=pos[i];
      if(solving(inp,row,col)) return true;
    }
    return false;
  }

  int _getStart(int val){
    if(val<4) return 1;
    if(val<7) return 4;
    return 7;
  }

}

/*


2 0 0   9 6 0   7 0 5
6 8 0   0 7 0   0 9 0
1 9 0   0 0 4   5 0 0

8 2 0   1 0 0   0 4 0
0 0 4   6 0 2   9 0 0
0 5 0   0 0 3   0 2 8

0 0 9   3 0 0   0 7 4
0 4 0   0 5 0   0 3 6
7 0 3   0 1 8   0 0 0
*/
