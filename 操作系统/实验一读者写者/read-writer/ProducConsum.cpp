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
#define MAX_THREAD_NUM  64 //�����߳���
#define SEM_MAX_FULL    64 //�ź��������ֵ
#define Read 'R'
#define Write 'W'

using namespace  std;

struct ThreadInfo
{
	int    serial;//�߳����
	char   entity;//�߳����
	double delay;//�ӳ�ʱ��
	double persist;//��д����ʱ��
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
		 //CreateThread����̴߳������ڵ��ý��̵ĵ�ַ�ռ��ϴ���һ���̣߳�
			//��ִ��ָ���ĺ��������ķ���ֵΪ�������̵߳ľ����
			h_Thread[i] = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)( Thread_Read),
			&thread_info[i],0,&thread_ID);//�ж�Ϊ��
		else
		{
			if(thread_info[i].entity == Write)//�ж�Ϊд
		 
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
 	//sem_full  = CreateSemaphore(NULL,0       ,SEM_MAX_FULL,"sem_full");//����һ����ֵΪ64���ź���������ͬ��
 	//sem_avail = CreateSemaphore(NULL,buff_num,SEM_MAX_FULL,"sem_avail");
	//HANDLE CreateSemaphore(
	//LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,  // SD
	//	LONG lInitialCount,                          // initial count
	//	LONG lMaximumCount,                          // maximum count
	//	LPCTSTR lpName                           // object name
		//)
	// lpSemaphoreAttributes��Ϊ�ź��������ԣ�һ���������ΪNULL
	//lInitialCount���ź�����ʼֵ��������ڵ���0������С�ڵ��� lpMaximumCount�����lInitialCount �ĳ�ʼֵΪ0������ź���Ĭ��Ϊunsignal״̬�����lInitialCount�ĳ�ʼֵ����0������ź���Ĭ��Ϊsignal״̬��
	//	lMaximumCount�� ��ֵΪ�����ź��������ֵ���������0
	//	lpName���ź��������֣����Ȳ��ܳ���MAX_PATH ��������ΪNULL����ʾ�������ź�������lpName��Ϊ��ʱ���ɴ����������ź���������ǰ�ź��������Ѵ��ڵ��ź�����������ͬʱ����ú�����ʾ�򿪸��ź�������ʱ����lInitialCount ��
    // lMaximumCount �������ԡ�
  	//WaitForMultipleObjects(n_thread,h_Thread,TRUE,-1);//����ָ��ʱ���ڵȴ�ָ������Ϊ����״̬

	printf("Task is Finished!\n");
	getch();
}


///////////////////////////////////////////

 
void  Thread_Read(void *p)
{

	DWORD m_delay;			 
	DWORD m_persist;		 
	int		m_serial;	 

	//������
	m_serial = ((ThreadInfo*)(p))->serial;
	m_delay  = (DWORD)(((ThreadInfo*)(p))->delay*INTE_PER_SEC);
	m_persist  = (DWORD)(((ThreadInfo*)(p))->persist*INTE_PER_SEC);
    while (true)
	{
		Sleep(m_delay);//����ʱ��
		printf("R thread %d send the Reading require\n", m_serial);
 	   WaitForSingleObject(r_mutex,-1); //�ȴ���
	   //EnterCriticalSection(&r_mutex);
 	   
	   readcount++;
	   if (readcount == 1)
	   {
		   EnterCriticalSection(&w_mutex);//�����ź���

	   }
	   ReleaseSemaphore(r_mutex, 1, NULL);
	 
	   printf("R thread %d Begin to Reading\n", m_serial);
	   Sleep(m_persist);//������
	   
	   printf("R thread %d Finish Reading.\n",m_serial);
	   WaitForSingleObject(r_mutex, -1);
	   readcount--;
	   if (readcount == 0)
	   {
		   LeaveCriticalSection(&w_mutex);

	   }
	   ReleaseSemaphore(r_mutex, 1, NULL);//�ͷŶ��ź�
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
	  Sleep(m_delay);//����ʱ��
 	  printf("W thread %d send the Writing require\n",m_serial);
 	  
	  EnterCriticalSection(&w_mutex);//�ȴ�������Դ
 	  printf("W thread %d Begin to Writing\n",m_serial);
	  Sleep(m_persist);//����ʱ��
	  printf("W thread %d Finish Writing.\n",m_serial);
 	  
 	  LeaveCriticalSection(&w_mutex);//�ͷŹ�����Դ
    }
}




