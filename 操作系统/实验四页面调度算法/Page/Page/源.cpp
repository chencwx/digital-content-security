#include "stdio.h"
#include <iostream>
#include <fstream>
#pragma warning(disable:4996)
#include <io.h>
#include "windows.h"
#include <stdlib.h>
using namespace std;
#define MAX_PAGE 1000                       // 常量MAX_PAGE，最大页面访问序列
#define MAX_BLOCK 100                      // 常量MAX_BLOCK，最大物理块数
#pragma warning(disable:4996)
int OUT_Data[MAX_BLOCK][MAX_PAGE];          // 用于存储要显示的数组
bool OUT_DataEnable[MAX_BLOCK][MAX_PAGE];   // 用于存储数组中的数据是否需要显示
int Page[MAX_PAGE];                        // 访问序列
int Block[MAX_BLOCK];                      // 物理块
int num[MAX_BLOCK];                      // 置换标志
int N;                                    // 页面个数
int M;                                    // 最小物理块数
int NO_Page_times;                          // 缺页次数
int FLAG[MAX_BLOCK];//用于clock算法



void Input()//输入数据（初始化）
{
	ifstream inFile;
	
	int i,select;//选择
	int max_num;
	i = 0;
	printf("请输入物理块数：");
	scanf("%d",&M);
	// 输入最小物理块数大于数据个数
	while(M > MAX_BLOCK)
	{
		printf("物理块数超过预定值，请重新输入：");
		scanf("%d",&M);
	}
	
	printf("请输入访问页面的个数：");
	scanf("%d",&N);
	// 输入页面的个数大于数据个数
	while(N > MAX_PAGE)
	{
		printf("页面个数超过预定值，请重新输入：");
		scanf("%d",&N);
	}
	printf("请输入最大页框号：");
	scanf("%d", &max_num);
	printf("请选择产生页面访问序列的方式(1.随机 2.从文件读取)：");
	scanf("%d",&select);

	switch(select)
	{
	case 1:
		// 产生随机访问序列
		for(i = 0;i < N;i++)
		{  
			Page[i] = rand()%(max_num+1);  // 随机数大小在0 - 9之间
		}
		system("cls");
		// 显示随机产生的访问序列
		printf("\n随机产生的访问序列为：");
		for(i = 0;i < N;i++)
		{
			printf("%d ",Page[i]);
		}
		printf("\n");
		break;
	case 2:
		inFile.open("data.txt");
		puts("Read Data File \n");
		// 输入访问序列
	
		while (inFile)
		{
			inFile >> Page[i];
			i++;
		}
		/*printf("请输入页面访问序列：\n");
		for(i = 0;i < N;i++)
			scanf("%d",&Page[i]);*/
		system("cls");
		// 显示输入的访问序列
		printf("\n输入的访问序列为：");
		for(i = 0;i < N;i++)
		{
			printf("%d ",Page[i]);
		}
		printf("\n");
	
		break;
	default:
		while(select != 1 && select != 2)
		{
			printf("请输入1或2选择相应方式:");
			scanf("%d",&select);
		}
		break;
	}
}

void Output()//输出数据
{
	int i,j;
	// 对所有数据操作
	printf("页面访问序号如下:\n");
	for(i = 0;i < N;i++)
	{
		printf("%d ",Page[i]);
	}
	printf("\n");
	printf("物理块页面信息如下:\n");
	for(j = 0;j < M;j++)
	{
		// 对所有数据操作
		for(i = 0;i < N;i++)
		{
			if( OUT_DataEnable[j][i] )
				printf("%d ",OUT_Data[j][i]);
			else
				printf("  ");
		}
		printf("\n");
	}
	printf("缺页次数: %d\n",NO_Page_times);
	printf("缺页率: %d %%\n",NO_Page_times * 100 / N);
	printf("---------------------------------------------------------------------------");
}


// 先进先出置换算法
void FIFO()
{
	int i,j;
	bool find;
	int change; 
	int tmp; // 临时变量
	int m = 1,n;

	NO_Page_times = 0;//缺页次数
	for(j = 0;j < M;j++)//对所有的物理块遍历，初始化
	{
		for(i = 0;i < N;i++)
		{
			OUT_DataEnable[j][i] = false;  // 初始化为false，表示没有要显示的数据
		}
	}		
	for(i = 0;i < M;i++)
	{
		num[i] = 0; //  大于等于MAX_BLOCK，表示块中没有数据，或需被替换掉
        // 所以经这样初始化（3 2 1），每次替换>=3的块，替换后计数值置1，
		// 同时其它的块计数值加1 ，成了（1 3 2 ），见下面先进先出程序段
	}
	// 确定当前页面是否在物理块中，在继续，不在置换
	///////////////////////////////////////////////////////////////////////////////////
	Block[0] = Page[0];
	//先初始化页面状态
	for(i = 1;m < M;i++)
	{
		int flag = 1;
		for(n = 0; n < m;n++)
		{
			if(Page[i] == Block[n]) flag = 0;
		}
		if(flag == 0) 
			continue;
		Block[m] = Page[i];
		m++;
	}
	//////////////////////////////////////////////////////////////////////////////////

	// 对有所数据操作
	for(i = 0;i < N;i++)
	{
		// 增加num，表示页面在物理块中的时间，从而判断是否是先进的
		for(j = 0;j < M;j++)
		{
			num[j]++;
		}
		find = false; // 表示块中有没有该数据
		for(j = 0;j < M;j++)
		{
			if( Block[j] == Page[i] )
			{
				find = true; 
			}
		}
		// 块中有该数据，判断下一个数据
		//设置要显示的数据
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // 设置显示数据
		}
		if( find ) continue;
			// 块中没有该数据
		printf("第%d次页面访问发生缺页中断，进行页面置换\n", i + 1);
			NO_Page_times++; // 缺页次数++  
		// 因为i是从0开始记，而M指的是个数，从1开始，所以i+1
		if( (i + 1) > M )//物理块是满的
		{
			//获得要替换的块指针
			tmp = 0;
			for(j = 0;j < M;j++)
			{
				if( tmp < num[j] ) 
				{
					tmp = num[j];
					change = j; // 获得离的最远的指针
				}
			}
		}
		//else change = i;
		// 替换
		Block[change] = Page[i]; 
		
		num[change] = 0; // 更新计数值，表示是刚进来的数据
		
		// 更新数据
		for(j = 0;j < M;j++)
		{
			OUT_Data[j][i] = Block[j];
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // 设置显示数据
		}
	}
	// 输出信息
	printf("\nFIFO内存置换信息如下（当前的物理块状态）:\n");
	Output();
}

// 最近最久未使用置换算法
void LRU()
{
	int i,j;
	bool find;
	int change; //要置换的界面
	int tmp; // 临时变量
	int m = 1,n;

	NO_Page_times = 0;
	for(j = 0;j < M;j++)
	{
		for(i = 0;i < N;i++)
		{
			OUT_DataEnable[j][i] = false;  // 初始化为false，表示没有要显示的数据
		}
	}
	for(i = 0;i < M;i++)
	{
		num[i] = 0 ; // 初始化计数器
	}
	// 确定当前页面是否在物理块中，在继续，不在置换
	///////////////////////////////////////////////////////////////////////////////////
	Block[0] = Page[0];
	//初始化页面（前三种页面序号不算在缺页中）
	for(i = 1;m < M;i++)
	{
		int flag = 1;
		for(n = 0; n < m;n++)
		{
			if(Page[i] == Block[n]) flag = 0;
		}
		if(flag == 0) continue;
		Block[m] = Page[i];
		m++;
	}
	//////////////////////////////////////////////////////////////////////////////////

	// 对有所数据操作
	for(i = 0;i < N;i++)
	{
		// 增加num
		for(j = 0;j < M;j++)
		{
			num[j]++;//每次页面访问时都加1
		}
		find = false; // 表示块中有没有该数据
		for(j = 0;j < M;j++)
		{
			if( Block[j] == Page[i] )
			{

				num[j] = 0;//每次访问将数值设为0，表示是最近访问，最终判断依据是：数值越大，最近越未访问
				find = true; 
			}
		}
		// 块中有该数据，判断下一个数据
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // 设置显示数据
		}
		if( find ) continue;
		printf("第%d次页面访问发生缺页中断，进行页面置换\n", i + 1);
		// 块中没有该数据
		NO_Page_times++;
		// 因为i是从0开始记，而MAX_BLOCK指的是个数，从1开始，所以i+1
		if( (i + 1) > M )
		{
			//获得要替换的块指针
			tmp = 0;
			for(j = 0;j < M;j++)
			{
				if( tmp < num[j] ) 
				{
					tmp = num[j];//数值最大的表示最久未访问的页面
					change = j; // 获得离的最远的指针
				}
			}
		}
		else change = i;
		// 替换
		Block[change] = Page[i]; 
		num[change] = 0;//刚替换的也是刚刚访问的
		
		// 保存要显示的数据
		for(j=0;j<M;j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ?(j <= i ? j : i) : j][i] = true; // 设置显示数据
		}
	
	}
	// 输出信息
	printf("\nLRU内存置换信息如下（当前的物理块状态）:\n");
	Output();
}



int CLOCK()
{
	int i, j;
	bool find;
	int change;
	int tmp; // 临时变量
	int m = 1, n;

	NO_Page_times = 0;
	for (j = 0; j < M; j++)
	{
		for (i = 0; i < N; i++)
		{
			OUT_DataEnable[j][i] = false;  // 初始化为false，表示没有要显示的数据
		}
	}
	for (i = 0; i < M; i++)
	{
		num[i] = 0; // 初始化计数器
	}
	// 确定当前页面是否在物理块中，在继续，不在置换
	///////////////////////////////////////////////////////////////////////////////////
	Block[0] = Page[0];
	//初始化页面（前三种页面序号不算在缺页中）
	for (i = 1; m < M; i++)
	{
		int flag = 1;
		for (n = 0; n < m; n++)
		{
			if (Page[i] == Block[n]) flag = 0;
		}
		if (flag == 0) continue;
		Block[m] = Page[i];
		m++;
	}
	//////////////////////////////////////////////////////////////////////////////////
	for (i = 0; i < M; i++)//初始化标志位
	{
		FLAG[i] = 0;
	}
	// 对有所数据操作
	for (i = 0; i < N; i++)
	{
		
		find = false; // 表示块中有没有该数据
		for (j = 0; j < M; j++)
		{
			if (Block[j] == Page[i])
			{
				FLAG[j] = 1;
				//num[j] = 0;//每次访问将数值设为0，表示是最近访问，最终判断依据是：数值越大，最近越未访问
				find = true;
			}
		

		}
		// 块中有该数据，判断下一个数据
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // 设置显示数据
		}
		if (find) continue;
		printf("第%d次页面访问发生缺页中断，进行页面置换\n", i + 1);
		// 块中没有该数据
		NO_Page_times++;
		int tag = 0;
		// 因为i是从0开始记，而MAX_BLOCK指的是个数，从1开始，所以i+1
		if ((i + 1) > M)//需要淘汰页面时，顺序检查各页面，访问位为0则淘汰；若为1则 置0，暂不淘汰。
		{
			//获得要替换的块指针
			tmp = 0;
			for (j = 0; j < M; j++)
			{
				if (FLAG[j] == 0)
				{

					change = j; // 获得置换的页面
					
					break;
				}
				else
					FLAG[j] = 0;
			}
			if (j == M)
			{
				for (j = 0; j < M; j++)
				{
					if (FLAG[j] == 0)
					{

						change = j; // 获得置换的页面
						break;
					}

				}
			}
		}
		//else change = i;
		// 替换
		Block[change] = Page[i];
		//num[change] = 0;//刚替换的也是刚刚访问的
		FLAG[change] = 1;
		// 保存要显示的数据
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // 设置显示数据
		}

	}
	// 输出信息
	printf("\nCLOCK内存置换信息如下（当前的物理块状态）:\n");
	Output();
	return 0;
}

int main(int argc, char* argv[])
{
	Input();
	int menu;
	//scanf("%d", &menu);
	printf("FIFO算法如下:\n");
	FIFO();
	printf("\nLRU算法如下:\n");
	LRU();
	printf("\nCLOCK算法如下:\n");
	CLOCK();

	return 0;
}