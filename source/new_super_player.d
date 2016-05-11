module source.new_super_player;

import std.stdio;
import std.algorithm;
import std.math;
import std.random;
import std.conv;
import std.random;


import source.seabattle;

class NewSuperPlayer : Player
{
    int curRow = -1;
    int curCol = 4;
    int step = 0;

    override Board battleMove()
    {
        int shots = 0;

        while (shots < myBoard.MaxShots())
        {
            int flag = 0;
            if (step < 2) {
                curRow++;
                curCol--;
                if (curCol < 0 || curRow > 9) {
                    curCol += 5;
                    curRow--;
                    while (curRow > 0 && curCol < 9) {
                        curRow--;
                        curCol++;
                    }
                }
                if (curCol > 9) {
                    curRow = 0;
                    curCol = 1;
                    step++;
                }
            }
            if (step == 2) {
                do
                {
                    curRow = uniform(0, ROWS);
                    curCol = uniform(0, COLS);
                    flag++;
                }
                while ( (enemyBoard.hits[curRow][curCol] == 'X' || enemyBoard.hits[curRow][curCol] == 'Y') && flag < 200);
            }
            if (step == 2)
                writeln(curRow, ' ', curCol, '\n');
            enemyBoard.hits[curRow][curCol] = 'Y';
            shots++;

        }


        return enemyBoard;
    }

    void get_ship(ref Board board, int sum) {

        int col, row;
        do {
            if (uniform(0, 2))
                col = 0;
            else
                col = 9;
            if (uniform(0, 2))
                row = 0;
            else
                row = 9;
        } while (board.ships[row][col] == 'O');

        if (uniform(0, 2)) {
            if (row == 9) {
                for (int i = 10 - sum; i < 10; i++) {
                    board.ships[i][col] = 'O';
                }
            }
            else {
                for (int i = 0; i < sum; i++) {
                    board.ships[i][col] = 'O';
                }
            }

        }
        else {
             if (col == 9) {
                for (int i = 10 - sum; i < 10; i++)
                    board.ships[row][i] = 'O';
            }
            else {
                for (int i = 0; i < sum; i++)
                    board.ships[row][i] = 'O';
            }
        }
    }


    override Board prepareMove()
    {
        initBoard (myBoard);
        initBoard (enemyBoard);

        get_ship(myBoard, 4);
        get_ship(myBoard, 3);
        get_ship(myBoard, 3);

        for (int len = 1; len < 3; len++)
              for (int num = 1; num <= 5 - len; num++)
              {
                  int rrow = uniform(0, 10);
                  int rcol = uniform(0, 10);
                  int rdir = uniform(0, 2);

                  if (rdir == 0)
                  {
                     bool flag1 = true;
                     if (rrow + len - 1 >= 10)
                     {
                        rrow = uniform(0, 10);
                        num--;
                        continue;
                     }
                     if (valid(myBoard, rrow - 1, rcol) && valid(myBoard, rrow + len, rcol))
                        flag1 = true;
                     else
                        flag1 = false;



                     for (int k = 0; k < len; k++)
                        if(!valid (myBoard, rrow + k, rcol + 1) || !valid (myBoard, rrow + k, rcol - 1) ||
                           !valid (myBoard, rrow + k, rcol))
                            flag1 = false;
                     if(flag1 == true)
                         for(int t = 0; t < len; t++)
                         {
                            myBoard.ships[rrow + t][rcol] = 'O';
                         }

                     else
                     {
                        rrow = uniform(0, 10);
                        num--;
                     }

                  }
                  else
                  {
                      if (rcol + len - 1 >= 10)
                      {
                          rcol = uniform(0, 10);
                          num--;
                          continue;
                      }
                      bool flag2 = true;
                      if (valid(myBoard, rrow, rcol - 1) && valid(myBoard, rrow, rcol + len))
                        flag2 = true;
                      else
                        flag2 = false;
                      for (int k = 0; k < len; k++)
                        if(!valid (myBoard, rrow + 1, rcol + k) || !valid (myBoard, rrow - 1, rcol + k) ||
                           !valid (myBoard, rrow, rcol + k))
                              flag2 = false;
                      if(flag2 == true)
                         for(int t = 0; t < len; t++)
                         {
                            myBoard.ships[rrow ][rcol + t] = 'O';
                         }



                      else
                      {
                        rcol = uniform(0, 10);
                        num--;
                      }
                  }
               }
        assert (finishPrepareMove (myBoard));
        return myBoard;
    }

    override void updateEnemyMove (Board newMyBoard)
    {
        myBoard = newMyBoard;
    }

    override void updateMyMove (Board newEnemyBoard)
    {
        enemyBoard = newEnemyBoard;
    }


}
