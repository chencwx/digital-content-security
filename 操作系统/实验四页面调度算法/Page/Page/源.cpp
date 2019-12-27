#include "stdio.h"
#include <iostream>
#include <fstream>
#pragma warning(disable:4996)
#include <io.h>
#include "windows.h"
#include <stdlib.h>
using namespace std;
#define MAX_PAGE 1000                       // ����MAX_PAGE�����ҳ���������
#define MAX_BLOCK 100                      // ����MAX_BLOCK������������
#pragma warning(disable:4996)
int OUT_Data[MAX_BLOCK][MAX_PAGE];          // ���ڴ洢Ҫ��ʾ������
bool OUT_DataEnable[MAX_BLOCK][MAX_PAGE];   // ���ڴ洢�����е������Ƿ���Ҫ��ʾ
int Page[MAX_PAGE];                        // ��������
int Block[MAX_BLOCK];                      // �����
int num[MAX_BLOCK];                      // �û���־
int N;                                    // ҳ�����
int M;                                    // ��С�������
int NO_Page_times;                          // ȱҳ����
int FLAG[MAX_BLOCK];//����clock�㷨



void Input()//�������ݣ���ʼ����
{
	ifstream inFile;
	
	int i,select;//ѡ��
	int max_num;
	i = 0;
	printf("���������������");
	scanf("%d",&M);
	// ������С��������������ݸ���
	while(M > MAX_BLOCK)
	{
		printf("�����������Ԥ��ֵ�����������룺");
		scanf("%d",&M);
	}
	
	printf("���������ҳ��ĸ�����");
	scanf("%d",&N);
	// ����ҳ��ĸ����������ݸ���
	while(N > MAX_PAGE)
	{
		printf("ҳ���������Ԥ��ֵ�����������룺");
		scanf("%d",&N);
	}
	printf("���������ҳ��ţ�");
	scanf("%d", &max_num);
	printf("��ѡ�����ҳ��������еķ�ʽ(1.��� 2.���ļ���ȡ)��");
	scanf("%d",&select);

	switch(select)
	{
	case 1:
		// ���������������
		for(i = 0;i < N;i++)
		{  
			Page[i] = rand()%(max_num+1);  // �������С��0 - 9֮��
		}
		system("cls");
		// ��ʾ��������ķ�������
		printf("\n��������ķ�������Ϊ��");
		for(i = 0;i < N;i++)
		{
			printf("%d ",Page[i]);
		}
		printf("\n");
		break;
	case 2:
		inFile.open("data.txt");
		puts("Read Data File \n");
		// �����������
	
		while (inFile)
		{
			inFile >> Page[i];
			i++;
		}
		/*printf("������ҳ��������У�\n");
		for(i = 0;i < N;i++)
			scanf("%d",&Page[i]);*/
		system("cls");
		// ��ʾ����ķ�������
		printf("\n����ķ�������Ϊ��");
		for(i = 0;i < N;i++)
		{
			printf("%d ",Page[i]);
		}
		printf("\n");
	
		break;
	default:
		while(select != 1 && select != 2)
		{
			printf("������1��2ѡ����Ӧ��ʽ:");
			scanf("%d",&select);
		}
		break;
	}
}

void Output()//�������
{
	int i,j;
	// ���������ݲ���
	printf("ҳ������������:\n");
	for(i = 0;i < N;i++)
	{
		printf("%d ",Page[i]);
	}
	printf("\n");
	printf("�����ҳ����Ϣ����:\n");
	for(j = 0;j < M;j++)
	{
		// ���������ݲ���
		for(i = 0;i < N;i++)
		{
			if( OUT_DataEnable[j][i] )
				printf("%d ",OUT_Data[j][i]);
			else
				printf("  ");
		}
		printf("\n");
	}
	printf("ȱҳ����: %d\n",NO_Page_times);
	printf("ȱҳ��: %d %%\n",NO_Page_times * 100 / N);
	printf("---------------------------------------------------------------------------");
}


// �Ƚ��ȳ��û��㷨
void FIFO()
{
	int i,j;
	bool find;
	int change; 
	int tmp; // ��ʱ����
	int m = 1,n;

	NO_Page_times = 0;//ȱҳ����
	for(j = 0;j < M;j++)//�����е�������������ʼ��
	{
		for(i = 0;i < N;i++)
		{
			OUT_DataEnable[j][i] = false;  // ��ʼ��Ϊfalse����ʾû��Ҫ��ʾ������
		}
	}		
	for(i = 0;i < M;i++)
	{
		num[i] = 0; //  ���ڵ���MAX_BLOCK����ʾ����û�����ݣ����豻�滻��
        // ���Ծ�������ʼ����3 2 1����ÿ���滻>=3�Ŀ飬�滻�����ֵ��1��
		// ͬʱ�����Ŀ����ֵ��1 �����ˣ�1 3 2 �����������Ƚ��ȳ������
	}
	// ȷ����ǰҳ���Ƿ���������У��ڼ����������û�
	///////////////////////////////////////////////////////////////////////////////////
	Block[0] = Page[0];
	//�ȳ�ʼ��ҳ��״̬
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

	// ���������ݲ���
	for(i = 0;i < N;i++)
	{
		// ����num����ʾҳ����������е�ʱ�䣬�Ӷ��ж��Ƿ����Ƚ���
		for(j = 0;j < M;j++)
		{
			num[j]++;
		}
		find = false; // ��ʾ������û�и�����
		for(j = 0;j < M;j++)
		{
			if( Block[j] == Page[i] )
			{
				find = true; 
			}
		}
		// �����и����ݣ��ж���һ������
		//����Ҫ��ʾ������
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // ������ʾ����
		}
		if( find ) continue;
			// ����û�и�����
		printf("��%d��ҳ����ʷ���ȱҳ�жϣ�����ҳ���û�\n", i + 1);
			NO_Page_times++; // ȱҳ����++  
		// ��Ϊi�Ǵ�0��ʼ�ǣ���Mָ���Ǹ�������1��ʼ������i+1
		if( (i + 1) > M )//�����������
		{
			//���Ҫ�滻�Ŀ�ָ��
			tmp = 0;
			for(j = 0;j < M;j++)
			{
				if( tmp < num[j] ) 
				{
					tmp = num[j];
					change = j; // ��������Զ��ָ��
				}
			}
		}
		//else change = i;
		// �滻
		Block[change] = Page[i]; 
		
		num[change] = 0; // ���¼���ֵ����ʾ�Ǹս���������
		
		// ��������
		for(j = 0;j < M;j++)
		{
			OUT_Data[j][i] = Block[j];
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // ������ʾ����
		}
	}
	// �����Ϣ
	printf("\nFIFO�ڴ��û���Ϣ���£���ǰ�������״̬��:\n");
	Output();
}

// ������δʹ���û��㷨
void LRU()
{
	int i,j;
	bool find;
	int change; //Ҫ�û��Ľ���
	int tmp; // ��ʱ����
	int m = 1,n;

	NO_Page_times = 0;
	for(j = 0;j < M;j++)
	{
		for(i = 0;i < N;i++)
		{
			OUT_DataEnable[j][i] = false;  // ��ʼ��Ϊfalse����ʾû��Ҫ��ʾ������
		}
	}
	for(i = 0;i < M;i++)
	{
		num[i] = 0 ; // ��ʼ��������
	}
	// ȷ����ǰҳ���Ƿ���������У��ڼ����������û�
	///////////////////////////////////////////////////////////////////////////////////
	Block[0] = Page[0];
	//��ʼ��ҳ�棨ǰ����ҳ����Ų�����ȱҳ�У�
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

	// ���������ݲ���
	for(i = 0;i < N;i++)
	{
		// ����num
		for(j = 0;j < M;j++)
		{
			num[j]++;//ÿ��ҳ�����ʱ����1
		}
		find = false; // ��ʾ������û�и�����
		for(j = 0;j < M;j++)
		{
			if( Block[j] == Page[i] )
			{

				num[j] = 0;//ÿ�η��ʽ���ֵ��Ϊ0����ʾ��������ʣ������ж������ǣ���ֵԽ�����Խδ����
				find = true; 
			}
		}
		// �����и����ݣ��ж���һ������
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // ������ʾ����
		}
		if( find ) continue;
		printf("��%d��ҳ����ʷ���ȱҳ�жϣ�����ҳ���û�\n", i + 1);
		// ����û�и�����
		NO_Page_times++;
		// ��Ϊi�Ǵ�0��ʼ�ǣ���MAX_BLOCKָ���Ǹ�������1��ʼ������i+1
		if( (i + 1) > M )
		{
			//���Ҫ�滻�Ŀ�ָ��
			tmp = 0;
			for(j = 0;j < M;j++)
			{
				if( tmp < num[j] ) 
				{
					tmp = num[j];//��ֵ���ı�ʾ���δ���ʵ�ҳ��
					change = j; // ��������Զ��ָ��
				}
			}
		}
		else change = i;
		// �滻
		Block[change] = Page[i]; 
		num[change] = 0;//���滻��Ҳ�Ǹոշ��ʵ�
		
		// ����Ҫ��ʾ������
		for(j=0;j<M;j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ?(j <= i ? j : i) : j][i] = true; // ������ʾ����
		}
	
	}
	// �����Ϣ
	printf("\nLRU�ڴ��û���Ϣ���£���ǰ�������״̬��:\n");
	Output();
}



int CLOCK()
{
	int i, j;
	bool find;
	int change;
	int tmp; // ��ʱ����
	int m = 1, n;

	NO_Page_times = 0;
	for (j = 0; j < M; j++)
	{
		for (i = 0; i < N; i++)
		{
			OUT_DataEnable[j][i] = false;  // ��ʼ��Ϊfalse����ʾû��Ҫ��ʾ������
		}
	}
	for (i = 0; i < M; i++)
	{
		num[i] = 0; // ��ʼ��������
	}
	// ȷ����ǰҳ���Ƿ���������У��ڼ����������û�
	///////////////////////////////////////////////////////////////////////////////////
	Block[0] = Page[0];
	//��ʼ��ҳ�棨ǰ����ҳ����Ų�����ȱҳ�У�
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
	for (i = 0; i < M; i++)//��ʼ����־λ
	{
		FLAG[i] = 0;
	}
	// ���������ݲ���
	for (i = 0; i < N; i++)
	{
		
		find = false; // ��ʾ������û�и�����
		for (j = 0; j < M; j++)
		{
			if (Block[j] == Page[i])
			{
				FLAG[j] = 1;
				//num[j] = 0;//ÿ�η��ʽ���ֵ��Ϊ0����ʾ��������ʣ������ж������ǣ���ֵԽ�����Խδ����
				find = true;
			}
		

		}
		// �����и����ݣ��ж���һ������
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // ������ʾ����
		}
		if (find) continue;
		printf("��%d��ҳ����ʷ���ȱҳ�жϣ�����ҳ���û�\n", i + 1);
		// ����û�и�����
		NO_Page_times++;
		int tag = 0;
		// ��Ϊi�Ǵ�0��ʼ�ǣ���MAX_BLOCKָ���Ǹ�������1��ʼ������i+1
		if ((i + 1) > M)//��Ҫ��̭ҳ��ʱ��˳�����ҳ�棬����λΪ0����̭����Ϊ1�� ��0���ݲ���̭��
		{
			//���Ҫ�滻�Ŀ�ָ��
			tmp = 0;
			for (j = 0; j < M; j++)
			{
				if (FLAG[j] == 0)
				{

					change = j; // ����û���ҳ��
					
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

						change = j; // ����û���ҳ��
						break;
					}

				}
			}
		}
		//else change = i;
		// �滻
		Block[change] = Page[i];
		//num[change] = 0;//���滻��Ҳ�Ǹոշ��ʵ�
		FLAG[change] = 1;
		// ����Ҫ��ʾ������
		for (j = 0; j < M; j++)
		{
			OUT_Data[j][i] = Block[j];
			//OUT_DataEnable[j][i] = true;
			OUT_DataEnable[i < M ? (j <= i ? j : i) : j][i] = true; // ������ʾ����
		}

	}
	// �����Ϣ
	printf("\nCLOCK�ڴ��û���Ϣ���£���ǰ�������״̬��:\n");
	Output();
	return 0;
}

int main(int argc, char* argv[])
{
	Input();
	int menu;
	//scanf("%d", &menu);
	printf("FIFO�㷨����:\n");
	FIFO();
	printf("\nLRU�㷨����:\n");
	LRU();
	printf("\nCLOCK�㷨����:\n");
	CLOCK();

	return 0;
}