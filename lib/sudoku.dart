bool backButtonPressed=false;

class SudokuData{
  List<List<SDT>> data;
  SudokuData(){
    data=List();
    for(int i=0; i<10; i++){
      List<SDT> _row=List();
      for(int j=0; j<10; j++) _row.add(SDT(row: j,col: i,isRed: false,value: 0));
      data.add(_row);
    }
  }

  List<List<int>> getListData(){
    List<List<int>> ret=List();
    for(int i=0; i<10; i++){
      List<int> ad=List();
      for(int j=0; j<10; j++) ad.add(data[i][j].value);
      ret.add(ad);
    }
    return ret;
  }

  void updateListData(List<List<int>> dat){
    for(int i=1; i<10; i++) for(int j=1; j<10; j++) data[i][j].value=dat[i][j];
  }

  List<bool> getSuggestionS(int _row,int _col){
    List<bool> ret=List();
    int _startRow=_getStartingOfSquare(_row);
    int _startCol=_getStartingOfSquare(_col);
    ret.add(true);
    for(int i=1; i<10; i++){
      bool loopContinue=true;
      //square checking
      if(loopContinue) for(int j=0; j<3; j++)for(int k=0; k<3; k++) if(data[j+_startCol][k+_startRow].value==i){loopContinue=false; break;}
      //row checking
      if(loopContinue) for(int j=1; j<10; j++) if(data[_col][j].value==i){loopContinue=false; break;}
      //col checking
      if(loopContinue) for(int j=1; j<10; j++) if(data[j][_row].value==i){loopContinue=false; break;}
      

       ret.add(loopContinue);
    }
    
    return ret;
  }

  int _getStartingOfSquare(int i){
    if(i<4) return 1;
    if(i<7) return 4;
    return 7;
  }

  void updateSDT(SDT sdt){
    data[sdt.col][sdt.row].isDefined=sdt.isDefined;
    data[sdt.col][sdt.row].isRed=sdt.isRed;
    data[sdt.col][sdt.row].value=sdt.value;
  }


  

  void printData(){
    for(int i=1; i<10; i++){
      String _temp='';
      for(int j=1; j<10; j++){
        _temp+=data[i][j].value.toString();
        if(j==3 || j==6) _temp+="   ";
      }
      print(_temp);
      if(i==3 || i==6) print("\n");
    }
  }

  bool validateInput(){
    for(int i=1; i<10; i++){
      for(int j=1; j<10; j++){
        int val=data[i][j].value;
        if(val!=0){
          //row checking
            for(int k=j+1; k<10; k++) if(val==data[i][k].value) return false;
          //col checking
            for(int k=i+1; k<10; k++) if(val==data[k][j].value) return false;
          //square box cheking
          int _s=_getStartingOfSquare(i),_y=_getStartingOfSquare(j);
          _s+=3; _y+=3;
          for(int k=i+1; k<_s; k++) for(int l=j+1; l<_y; l++ ) if(val==data[k][l].value) return false;
        }
      }
    }

    return true;
  }

  bool validateOutput(){
    int _temp;
    for(int i=1; i<10; i++){
        for(int j=1; j<10; j++)
        {
          _temp=data[i][j].value;
            if(_temp==0) return false;

            //row checking
            for(int k=j+1; k<10; k++) if(_temp==data[i][k].value) return false;
            //col checking
            for(int k=i+1; k<10; k++) if(_temp==data[k][j].value) return false;
            //square checking
            int _tempQ=_getStartingOfSquare(i),_tempO=_getStartingOfSquare(j);
            for(int k=i+1; k<_tempQ+3; ) for(int l=j+1; l<_tempO+3; l++)
              if(_temp==data[k][l].value) return false;

        }
    }
    return true;
  }
}

class SDT{
  int value=0;
  int row=1;
  int col=1;
  bool isDefined=true;
  bool isRed=false;
  SDT({this.col=1,this.isDefined=false,this.row=1,this.value=0,this.isRed=false});
}
///
///

//

/*


class SudokuSolver{
  SudokuData input;
  bool foundSolution=false;
  int level;
  List<Arr1D> pos;
  int rop,cop;

  SudokuSolver({this.input,this.pos,this.level=1,this.rop,this.cop}){
    foundSolution=false;
    level=this.level;
    print('--------------------------');
    print("Level : $level ");
    input.printData();


    for(int i=0; i<10; i++) index.add(_tindex);



    if(level==1){
      if(_validateInput()) { _createPossibilities();  _solveSudoku();
       }
      else{ foundSolution=false; print("wrong input");}
    } else if(level<=pos.length) {
        for(int i=0; i<pos.length; i++) index[pos[i].col][pos[i].row]=i;
        _removeValueFromPos(input.data[cop][rop].value, rop, cop);
        _printPosibilities();
        print('solving');
        //_solveSudoku();
    }
  }


  _createPossibilities(){
    pos=List();
    //create possibilities
    for(int i=1; i<10; i++) for(int j=1; j<10; j++){
      if(input.data[i][j].value==0){
        List<int> _tempList= new List();
        List<bool> _avail=input.getSuggestionS(j,i);
        for(int k=1; k<10;  k++)  if(_avail[k]) _tempList.add(k);

         pos.add(Arr1D(i,j,_tempList));
      }
    }
  }

  _printPosibilities(){
    for(int i=0; i<pos.length; i++){
      String x="$i  ${pos[i].col}  ${pos[i].row} ";
      for(int j=0; j<pos[i].pos.length; j++) x+=pos[i].pos[j].toString();
      print(x);
    }
  }

  List<List<int>> index=List();
  List<int> _tindex=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];

   _solveSudoku() {

    bool _loopContinue=true;
    while( _loopContinue) {_loopContinue=_singleStepSolution();}

    if(_validateOutput()) foundSolution=true; 
    else{
      //guess mode on
      print('guess mode on');
      SudokuData _tempSudoku=new SudokuData();
      _tempSudoku.data=List.from(input.data);
      List<int> _tempPos=List.from(pos[0].pos);
      int _tempCol=pos[0].col;
      int _tempRow=pos[0].row;

      //initilize this data
      int _currentVal;
      for(int i=0; i<_tempPos.length && !foundSolution && !backButtonPressed ; i++){
        _currentVal=_tempPos[i];
        List<Arr1D> _arrTemp=List.from(pos);
        _tempSudoku.data[_tempCol][_tempRow].value=_currentVal;
        SudokuSolver _sudokoSolver=new SudokuSolver(level:level+1,input:_tempSudoku,pos:_arrTemp,rop:_tempRow,cop:_tempCol); //initilize here
        if(_sudokoSolver.foundSolution){input=_sudokoSolver.input; foundSolution=true; i=10;}
        else foundSolution=false;
      }
    }
  }

  bool _singleStepSolution(){
    int found=0,_currentRow,_currentCol,val;
    for(int i=0; i<pos.length; i++){
      _currentCol=pos[i].col;
      _currentRow=pos[i].row;
      if(pos[i].pos.length==1){
        _removeValueFromPos(pos[i].pos[0], _currentRow, _currentCol);
        found++;
      }else{
        //check value in single times
        for(int j=0; j<pos[i].pos.length; j++){
          val=pos[i].pos[j];
          if(_searchInRowColPos(val, _currentRow, _currentCol, true) || _searchInRowColPos(val, _currentRow, _currentCol, false) ){
            _removeValueFromPos(val, _currentRow, _currentCol);
            found++;
            break;
          }
        }
      }
    }
    if(found==0) return false;
    else return true;
  }

  _removeValueFromOne(int _row,int _col, int val){

    int _ind=index[_col][_row];
    if(_ind!=-1){
      for(int i=0; i<pos[_ind].pos.length; i++){
        if(pos[_ind].pos[i]==val){
          print("$val $_row $_col $_ind");
          pos[_ind].pos.removeAt(i);
          if(pos[_ind].pos.length==0){input.data[_col][_row].value=val; pos.removeAt(_ind); _swapItValue(_ind);}
          break;
        }
      }
    }
  }

  _removeValueFromPos(int val,int _row,int _col){
    for(int i=1; i<10; i++){
       _removeValueFromOne(i, _col, val);
       _removeValueFromOne(_row, i, val);
    }
    int _startR=_getStartingOfSquare(_row),_startC=_getStartingOfSquare(_col);
    for(int i=0; i<3; i++) for(int j=0; j<3; j++) _removeValueFromOne(j+_startR,i+_startC,val);
    index[_col][_row]=-1;
  }

  _swapItValue(int xx){
      index=List();
      for(int i=0; i<10; i++) index.add(_tindex);
      for(int i=0; i<pos.length; i++) index[pos[i].col][pos[i].row]=i;
  }

  bool _searchInRowColPos(int val,int row,int col,bool inRow){
    int _times=0;
    int _indexAt;
    for(int i=1; i<10; i++){
        _indexAt=inRow?  index[i][row]: index[col][i];
        if(_indexAt!=-1){
          for(int k=0; k<pos[_indexAt].pos.length; k++){
            if(pos[_indexAt].pos[k]==val) _times++;
            //print('..');
          }
        }
      }
    if(_times==1) return true;
    return false;
  }

  int _getStartingOfSquare(int i){
    if(i<4) return 1;
    if(i<7) return 4;
    return 7;
  }

  bool _validateInput(){
    for(int i=1; i<10; i++){
      for(int j=1; j<10; j++){
        int val=input.data[i][j].value;
        if(val!=0){
          //row checking
            for(int k=j+1; k<10; k++) if(val==input.data[i][k].value) return false;
          //col checking
            for(int k=i+1; k<10; k++) if(val==input.data[k][j].value) return false;
          //square box cheking
          int _s=_getStartingOfSquare(i),_y=_getStartingOfSquare(j);
          _s+=3; _y+=3;
          for(int k=i+1; k<_s; k++) for(int l=j+1; l<_y; l++ ) if(val==input.data[k][l].value) return false;
        }
      }
    }

    return true;
  }

  bool _validateOutput(){
    int _temp;
    for(int i=1; i<10; i++) //for 0 checking
        for(int j=1; j<10; j++)
        {
          _temp=input.data[i][j].value;
            if(_temp==0) return false;

            //row checking
            for(int k=j+1; k<10; k++) if(_temp==input.data[i][k].value) return false;
            //col checking
            for(int k=i+1; k<10; k++) if(_temp==input.data[k][j].value) return false;
            //square checking
            int _tempQ=_getStartingOfSquare(i),_tempO=_getStartingOfSquare(j);
            for(int k=i+1; k<_tempQ+3; ) for(int l=j+1; l<_tempO+3; l++)
              if(_temp==input.data[k][l].value) return false;

        }
    return true;
  }



}















// class SudokuSolver{
//   SudokuData input;
//   bool foundSolution=false;
//   int level;
//   int removingRow,removingCol;
//   Function setState;
//   List<Arr1D> limted;

//   SudokuSolver({this.input,this.limted,this.level=1,this.removingCol,this.removingRow,this.setState}){
//     foundSolution=false;
//     level=this.level;
//     if(level==1){
//       if(_validateInput()) {_createPossibilities(); solveSudoku();}
//       else foundSolution=false;
//     } else if(level<100){
//        setState();
//         int _removeWhat=input.data[removingCol][removingRow].value;
//         _removePossibilities(_removeWhat, removingRow,removingCol);
//         solveSudoku();
//     }
//   }

//   _createPossibilities(){
//     //initilizing
//     List<List<int>> _tempF=List();
//     List<int> _tempS=List();
//     for(int i=0; i<10; i++) _tempF.add(_tempS);
//     for(int i=0; i<10; i++) pos.add(_tempF);

//     //create possibilities
//     for(int i=1; i<10; i++) for(int j=1; j<10; j++){
//       if(input.data[i][j].value==0){
//         List<int> _tempList=List();
//         List<bool> _avail=input.getSuggestionS(j,i);
//         for(int k=1; k<10;  k++)  if(_avail[k]) _tempList.add(k);
//         for(int i=0; i<_tempList.length; i++) pos[i][j]=_tempList;
//       }
//     }
//   }

//   Future solveSudoku() async{
//     while( _singleStepSolution()) continue;
//     if(_validateOutput()) foundSolution=true;
//     else{
//       //guess mode on
//       int _tempRow,_tempCol,_tempVal=0,_minLen=0;
//       for(int i=1; i<10; i++) for(int j=1; j<10; j++){
//         if(input.data[i][j].value==0){
//           if(_tempVal==0){_tempRow=j; _tempCol=i; _minLen=pos[i][j].length;}
//           else{
//             if(_minLen>pos[i][j].length){
//               _tempRow=j;
//               _tempCol=i;
//               _minLen=pos[i][j].length;
//             }
//           }
//         }
//       }
//       List<List<List<int>>> _tempPos=pos;
//       SudokuData _tempSudoku=input;

//       //initilize this data
//       int _currentVal;
//       for(int i=0; i<_minLen && !foundSolution; i++){
//         _currentVal=pos[_tempCol][_tempRow][i];
//         _tempSudoku.data[_tempCol][_tempRow].value=_currentVal;
//         SudokuSolver _sudokoSolver=SudokuSolver(level:level+1,input:_tempSudoku,pos:_tempPos,setState: this.setState,removingCol: _tempCol,removingRow:_tempRow); //initilize here
//         if(_sudokoSolver.foundSolution){input=_sudokoSolver.input; foundSolution=true; i=10;}
//         else foundSolution=false;
//       }
//     }
//   }

//   bool _singleStepSolution(){
//     print("----$level");
//     int found=0;
//     int tt=0;
//     int _temp;
//     for(int i=1; i<10; i++){
//         for(int j=1; j<10; j++){
//             _temp=input.data[i][j].value;
//             if(_temp!=0){
//               for(int k=0; k<pos[i][j].length; k++){
//                 tt=pos[i][j][k];
//                 if(!_checkValueInRow(tt,i)){
//                     if(_checkValueInRowPos(tt,i,1)){
//                         input.data[i][j].value=tt;
//                         _removePossibilities(tt,i,j);
//                         found++;
//                         break;
//                     }
//                 }
//                 if(!_checkValueInCol(tt,j)){
//                     if(_checkValueInColPos(tt,j,1)){
//                         input.data[i][j].value=tt;
//                         _removePossibilities(tt,i,j);
//                         found++;
//                         break;
//                     }
//                 }

//             }
//             }
//         }
//     }
//     if(found>0) return true;
//     return false;
//   }

//   // _printPossibilites(){ 
//   //   for(int i=1; i<10; i++){
//   //     String line="";
//   //     for(int j=1; j<10; j++){
//   //       if(input.data[i][j].value!=0) line+="-"+input.data[i][j].value.toString()+"-";
//   //        else   for(int k=0; k<pos[i][j].length; k++) line+=pos[i][j][k].toString();
//   //       line+=" ";
//   //       if(j==3 || j==6) line+="  |  ";
//   //     }
//   //     print(line);
//   //     if(i==3 || i==6) print(" ");
//   //   }
//   // }


//   bool _checkValueInRow(int val,int col){
//     for(int i=1; i<10; i++) if(input.data[col][i].value==val) return true;
//     return false;
//   }
//   bool _checkValueInCol(int val,int row){
//     for(int i=1; i<10; i++) if(input.data[i][row].value==val) return true;
//     return false;
//   }
//   // bool _checkValueInSquare(int val,int row,int col){
//   //   int _startRow=_getStartingOfSquare(row);
//   //   int _startCol=_getStartingOfSquare(col);

//   //   for(int i=0; i<3; i++) for(int j=0; j<3; j++) if(input.data[i+_startCol][j+_startRow].value==val) return true;
//   //   return false;
//   // }




//   bool _checkValueInRowPos(int val,int col,int times){
//     int _temp=0;
//     for(int i=1; i<10; i++){
//       if(input.data[col][i].value==0){
//         for(int j=0; j<pos[col][i].length; j++)
//           if(pos[col][i][j]==val) _temp++;
//       }
//     }

//     if(_temp==times) return true;
//     return false;
//   }
//   bool _checkValueInColPos(int val,int row,int times){
//     int _temp=0;
//     for(int i=1; i<10; i++){
//       if(input.data[i][row].value==0){
//         for(int j=0; j<pos[i][row].length; j++)
//           if(pos[i][row][j]==val) _temp++;
//       }
//     }

//     if(_temp==times) return true;
//     return false;
//   }

//   _removePossibilities(int val,int row,int col){
//     //removing val from col
//     for(int i=1; i<10; i++) if(input.data[i][row].value==0) _removeValueFromPoss(val, row, i);
//     //removing val from col
//     for(int i=1; i<10; i++) if(input.data[col][i].value==0) _removeValueFromPoss(val,i, col);
//     //removing val from square
//     int _s=_getStartingOfSquare(row),_t=_getStartingOfSquare(col);
//     for(int i=_t; i<_t+3; i++) for(int j=_s; j<_s+3; j++) if(input.data[i][j].value==0) _removeValueFromPoss(val,j,i);
//   }

//   _removeValueFromPoss(int val, int row,int col){
//     for(int i=0; i<pos[col][row].length; i++){
//       if(pos[col][row][i]==val){
//         pos[col][row].remove(val);
//         return;
//       }
//     }
//   }
//   void _removeValueFromColPos(int val,int col){
//     for(int i=1; i<10; i++){
//       if(input.data[col][i].value==0){
//         for(int j=0; j<pos[col][i].length; j++)
//           if(pos[col][i][j]==val) pos[col][i].removeAt(j);
//       }
//     }
//   }
//   void _removeValueFromRowPos(int val,int row){
//     for(int i=1; i<10; i++){
//       if(input.data[i][row].value==0){
//         for(int j=0; j<pos[i][row].length; j++)
//           if(pos[i][row][j]==val) pos[i][row].removeAt(j);
//       }
//     }
//   }

//   int _getStartingOfSquare(int i){
//     if(i<4) return 1;
//     if(i<7) return 4;
//     return 7;
//   }

//   bool _validateInput(){
//     for(int i=1; i<10; i++){
//       for(int j=1; j<10; j++){
//         int val=input.data[i][j].value;
//         if(val!=0){
//           //row checking
//             for(int k=j+1; k<10; k++) if(val==input.data[i][k].value) return false;
//           //col checking
//             for(int k=i+1; k<10; k++) if(val==input.data[k][j].value) return false;
//           //square box cheking
//           int _s=_getStartingOfSquare(i),_y=_getStartingOfSquare(j);
//           _s+=3; _y+=3;
//           for(int k=i+1; k<_s; k++) for(int l=j+1; l<_y; l++ ) if(val==input.data[k][l].value) return false;
//         }
//       }
//     }

//     return true;
//   }

//   bool _validateOutput(){
//     int _temp;
//     for(int i=1; i<10; i++) //for 0 checking
//         for(int j=1; j<10; j++)
//         {
//           _temp=input.data[i][j].value;
//             if(_temp==0) return false; //for 0 checking
//             //row checking
//             for(int k=j+1; k<10; k++) if(_temp==input.data[i][k].value) return false;
//             //col checking
//             for(int k=i+1; k<10; k++) if(_temp==input.data[k][j].value) return false;
//             //square checking
//             int _tempQ=_getStartingOfSquare(i),_tempO=_getStartingOfSquare(j);
//             for(int k=i+1; k<_tempQ+3; ) for(int l=j+1; l<_tempO+3; l++)
//               if(_temp==input.data[k][l].value) return false;

//         }
//     return true;
//   }



// }

class Arr1D{
  int row,col;
  List<int> pos;
  Arr1D(int co,int ro, List<int> d){
    row=ro; col=co; pos=d;
  }
}

*/