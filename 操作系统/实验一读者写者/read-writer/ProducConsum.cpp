// ReadWrite.cpp : Defines the entry point for the console application.
//https://wenku.baidu.com/view/e91fc15b68eae009581b6bd97f1922791688be61.html

#include "stdafx.h"


#include "windows.h"
#include <conio.h>
#include <stdlib.h>
//#include <fstream.h>
#include <fstream>
#include <io.h>
#include <string.h>
#include <stdio.h>
#define MSC_VER

#define INTE_PER_SEC 100 
#define MAX_THREAD_NUM  64 //最大的线程量
#define SEM_MAX_FULL    64 //信号量的最大值
#define Read 'R'
#define Write 'W'

using namespace  std;

struct ThreadInfo
{
	int    serial;//线程序号
	char   entity;//线程类别
	double delay;//延迟时间
	double persist;//读写持续时间
};


//int  buff_num;
int readcount = 0;

//CRITICAL_SECTION r_mutex; 
CRITICAL_SECTION w_mutex;

//HANDLE sem_full; 
//HANDLE sem_avail;
HANDLE r_mutex;

 
void  ReadWrite(char *file);
void  Thread_Read(void *p);
void  Thread_Write(void *p);
 

int main(int argc, char* argv[])
{
	ReadWrite("pc_data.txt");
    

	return 0;
}
//3
//1 P 1 1
//2 P 2 1
//3 P 3 1
//4 P 4 1
//5 P 5 1
//6 C 2 1
///////////////////////////////////////////
void ReadWrite(char *file)
{
	DWORD n_thread = 0;  
	DWORD thread_ID ;	 
 
	HANDLE		h_Thread[MAX_THREAD_NUM];
	ThreadInfo  thread_info[MAX_THREAD_NUM];

 
	ifstream inFile;
	inFile.open(file);
	puts("Read Data File \n");

	//inFile >> buff_num;
	while(inFile)
	{
		inFile >>  thread_info[n_thread].serial;
		inFile >>  thread_info[n_thread].entity;
		inFile >>  thread_info[n_thread].delay;
		inFile >>  thread_info[n_thread].persist;
		n_thread++;
		inFile.get();
	}


	for(int i=0;i<(int)(n_thread);i++)
	{
		if(thread_info[i].entity == Read)
		 //CreateThread完成线程创建，在调用进程的地址空间上创建一个线程，
			//以执行指定的函数；它的返回值为所创建线程的句柄。
			h_Thread[i] = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)( Thread_Read),
			&thread_info[i],0,&thread_ID);//判断为读
		else
		{
			if(thread_info[i].entity == Write)//判断为写
		 
			h_Thread[i] = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)( Thread_Write),
			&thread_info[i],0,&thread_ID);

			else
			{
				puts("Bad File\n");
				exit(0);
			}

		}
	}

    //printf("Buff  %d\n",buff_num);

 	//InitializeCriticalSection(&r_mutex);
	InitializeCriticalSection(&w_mutex);
	r_mutex = CreateSemaphore(NULL, 1, SEM_MAX_FULL, "r_mutex"); 
 	//sem_full  = CreateSemaphore(NULL,0       ,SEM_MAX_FULL,"sem_full");//创建一个数值为64的信号量，用于同步
 	//sem_avail = CreateSemaphore(NULL,buff_num,SEM_MAX_FULL,"sem_avail");
	//HANDLE CreateSemaphore(
	//LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,  // SD
	//	LONG lInitialCount,                          // initial count
	//	LONG lMaximumCount,                          // maximum count
	//	LPCTSTR lpName                           // object name
		//)
	// lpSemaphoreAttributes：为信号量的属性，一般可以设置为NULL
	//lInitialCount：信号量初始值，必须大于等于0，而且小于等于 lpMaximumCount，如果lInitialCount 的初始值为0，则该信号量默认为unsignal状态，如果lInitialCount的初始值大于0，则该信号量默认为signal状态，
	//	lMaximumCount： 此值为设置信号量的最大值，必须大于0
	//	lpName：信号量的名字，长度不能超出MAX_PATH ，可设置为NULL，表示无名的信号量。当lpName不为空时，可创建有名的信号量，若当前信号量名与已存在的信号量的名字相同时，则该函数表示打开该信号量，这时参数lInitialCount 和
    // lMaximumCount 将被忽略。
  	//WaitForMultipleObjects(n_thread,h_Thread,TRUE,-1);//可在指定时间内等待指定对象为可用状态

	printf("Task is Finished!\n");
	getch();
}


///////////////////////////////////////////

 
void  Thread_Read(void *p)
{

	DWORD m_delay;			 
	DWORD m_persist;		 
	int		m_serial;	 

	//读参数
	m_serial = ((ThreadInfo*)(p))->serial;
	m_delay  = (DWORD)(((ThreadInfo*)(p))->delay*INTE_PER_SEC);
	m_persist  = (DWORD)(((ThreadInfo*)(p))->persist*INTE_PER_SEC);
    while (true)
	{
		Sleep(m_delay);//延续时间
		printf("R thread %d send the Reading require\n", m_serial);
 	   WaitForSingleObject(r_mutex,-1); //等待读
	   //EnterCriticalSection(&r_mutex);
 	   
	   readcount++;
	   if (readcount == 1)
	   {
		   EnterCriticalSection(&w_mutex);//互斥信号量

	   }
	   ReleaseSemaphore(r_mutex, 1, NULL);
	 
	   printf("R thread %d Begin to Reading\n", m_serial);
	   Sleep(m_persist);//读操作
	   
	   printf("R thread %d Finish Reading.\n",m_serial);
	   WaitForSingleObject(r_mutex, -1);
	   readcount--;
	   if (readcount == 0)
	   {
		   LeaveCriticalSection(&w_mutex);

	   }
	   ReleaseSemaphore(r_mutex, 1, NULL);//释放读信号
	}
	
}


///////////////////////////////////////////
 
void  Thread_Write(void *p)
{

	DWORD	m_delay;		 
	DWORD	m_persist;		 
	int		m_serial;		 
 
	m_serial = ((ThreadInfo*)(p))->serial;
	m_delay  = (DWORD)(((ThreadInfo*)(p))->delay*INTE_PER_SEC);
	m_persist  = (DWORD)(((ThreadInfo*)(p))->persist*INTE_PER_SEC);

    while (true)
	{ 
	  Sleep(m_delay);//延续时间
 	  printf("W thread %d send the Writing require\n",m_serial);
 	  
	  EnterCriticalSection(&w_mutex);//等待共享资源
 	  printf("W thread %d Begin to Writing\n",m_serial);
	  Sleep(m_persist);//持续时间
	  printf("W thread %d Finish Writing.\n",m_serial);
 	  
 	  LeaveCriticalSection(&w_mutex);//释放共享资源
    }
}




