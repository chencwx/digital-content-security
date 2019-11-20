#include <iostream>
#include <string>
using namespace std;
#pragma warning(disable : 4996)
struct time //ʱ������ݽṹ
{
	int hour;
	int minute;
};

struct Job //��ҵ
{
	int num;//��ҵ���
	string jobname;   //��ҵ��
	time cometime;      //����ʱ��
	int runtime;      //��ҵ��������ʱ��
	time starttime;   //��ҵ��ʼʱ��
	time endtime;     //��ҵ����ʱ��
	int cycletime;    //��ҵ��תʱ��
	int waittime;//�ȴ�ʱ��
    float weight_ctime;     //��ҵ��Ȩ��תʱ��=��ҵ��תʱ��/��ҵ����ʱ��
	bool running;      //�Ƿ�������
};

double T=0;//��ҵƽ����תʱ��
double W=0;//��ҵ��Ȩƽ����תʱ��

void Input(Job job[],int &n)  //������ҵ��Ϣ
{
	cout<<"**********�밴��ҵ����ʱ���Ⱥ�˳������*********"<<endl;
	cout << "��ҵ���" << "\t" << "��ҵ����" << "\t" << "��ҵ��ʼʱ��" << "\t" << "��ҵҪ������ʱ��" << "\t" << endl;
	for(int i=0;i<n;i++)
	{
		
		cin >> job[i].num;
		
		cin>>job[i].jobname;
		
		scanf("%d:%d",&job[i].cometime.hour,&job[i].cometime.minute);
		
		
		cin>>job[i].runtime;

		job[i].starttime.hour=0;
		job[i].starttime.minute=0;
		job[i].endtime.hour=0;
		job[i].endtime.minute=0;
		job[i].cycletime=0;
		job[i].weight_ctime=0;
		job[i].running=false; //���Ϊδ����
		cout<<"*********************"<<endl;
	}
}

void Init(Job job[],int &n)//��ʼ��
{
	for(int i=0;i<n;i++)
	{
		job[i].starttime.hour=0;
		job[i].starttime.minute=0;
		job[i].endtime.hour=0;
		job[i].endtime.minute=0;
		job[i].cycletime=0;
		job[i].weight_ctime=0;
		job[i].running=false; //���Ϊδ����
	}
	T=0;
	W=0;
}

void Displaytime(time time)    //��ʾʱ��
{
	cout<<time.hour<<":"<<time.minute;
}
int timeMinu(time t1,time t2)  //����ʱ���,ʱ��t1��t2��
{
	return t1.hour*60+t1.minute-(t2.hour*60+t2.minute);
}
time timeAdd(time time,int addtime) //ʱ�����
{
	time.hour+=addtime/60;
	time.minute+=addtime%60;
	if(time.minute>=60)
	{
		time.hour++;
		time.minute-=60;
	}
	return time;
}
bool compare(time t1,time t2)//�Ƚ�����ʱ��Ĵ�С����һ����ͷ���TRUE
{
	if(t1.hour>t2.hour)
		return true;
	else if(t1.hour==t2.hour&&t1.minute>=t2.minute)
		return true;
	else
		return false;
}

void Result(Job job[],int &n)  //��ʾ���
{
	cout<<"jobnum\tjobname\tcometime\truntime\tsttime\tendtime\t�ȴ�ʱ��\t��תʱ��(����)\t��Ȩ��תʱ��"<<endl;
	cout<<"****************************************************************************************************"<<endl;
	for(int i=0;i<n;i++)
	{
		cout << job[i].num << "\t";
		cout<<job[i].jobname<<"\t";
		Displaytime(job[i].cometime);
		cout<<"\t"<<job[i].runtime<<"\t";
		Displaytime(job[i].starttime);
		cout<<"\t";
		Displaytime(job[i].endtime);
		job[i].waittime = timeMinu(job[i].starttime, job[i].cometime);
		cout << "\t" << job[i].waittime;
		cout<<"\t  "<<job[i].cycletime<<"\t\t  "<<job[i].weight_ctime<<endl;
	}
	cout<<"��ҵƽ����תʱ�䣺T="<<T/(n*1.0)<<endl;
	cout<<"��ҵ��Ȩƽ����תʱ�䣺W="<<W/(n*1.0)<<endl;
}

int minRuntime(Job job[],int &n,time &t) //�ҳ���ҵ�������ҵ�±�
{
	int min=-1;
	for(int i=0;i<n;i++)
	{
		if(job[i].running==false && compare(t,job[i].cometime)==true)
		{
			min=i;
			break;
		}	
	}
	for(int j=min+1;j<n;j++)
		if(job[j].running==false && job[j].runtime<job[min].runtime && compare(t,job[j].cometime)==true)
			min=j;
	return min;
}

void SJF(Job job[],int &n)//����ҵ������ҵ����
{
	struct time t;
	job[0].starttime.hour=job[0].cometime.hour;//��һ�������Ҫ����
	job[0].starttime.minute=job[0].cometime.minute;
	job[0].endtime=timeAdd(job[0].starttime,job[0].runtime);
	job[0].running=true;
	job[0].cycletime=timeMinu(job[0].endtime,job[0].cometime);
	job[0].weight_ctime=job[0].cycletime*1.0/job[0].runtime;
	T+=job[0].cycletime;//���ڼ���ƽ����תʱ��
	W+=job[0].weight_ctime;//�������ۼ�Ȩ��תʱ��
	t=job[0].endtime;
	while(minRuntime(job,n,t)!=-1)
	{
		int i=minRuntime(job,n,t);//�ҵ�Ŀǰδ���Ķ���������ʱ����̵�
		if(compare(job[i].cometime,t))//����ʱ������һ������ʱ�����
			job[i].starttime=job[i].cometime;
		else
			job[i].starttime=t;
		job[i].endtime=timeAdd(job[i].starttime,job[i].runtime);
		job[i].running=true;
		job[i].cycletime=timeMinu(job[i].endtime,job[i].cometime);
	    job[i].weight_ctime=job[i].cycletime*1.0/job[i].runtime;
		T+=job[i].cycletime;
	    W+=job[i].weight_ctime;
		t=job[i].endtime;
	}
}

int Firstcometime(Job job[],int &n) //�ҳ���ҵ�����ȵ���
{
	int min=-1;
	for(int i=0;i<n;i++)
	{
		if(job[i].running==false)
		{
			min=i;
			break;
		}
	}
	for(int j=min+1;j<n;j++)
		if(job[j].running==false && compare(job[min].cometime,job[j].cometime))//�Ƚϸ����ʱ�䣬������
			min=j;
	return min;
}
void FCFS(Job job[],int &n)//�����ȷ�����ҵ����
{
	struct time t;
	job[0].starttime.hour=job[0].cometime.hour;//��һ�����Ŀ϶�����
	job[0].starttime.minute=job[0].cometime.minute;
	job[0].endtime=timeAdd(job[0].starttime,job[0].runtime);
	job[0].running=true;
	job[0].cycletime=timeMinu(job[0].endtime,job[0].cometime);
	job[0].weight_ctime=job[0].cycletime*1.0/job[0].runtime;
	T+=job[0].cycletime;
	W+=job[0].weight_ctime;
	t=job[0].endtime;
	while(Firstcometime(job,n)!=-1)//ֱ�����е���ҵ�����Ϊֹ
	{
		int i=Firstcometime(job,n);//�ҵ�Ŀǰδ����ҵ�����ȵ����
		if(compare(job[i].cometime,t))//�Ƚϵ���ʱ�����һ��������ҵ�Ľ���ʱ��
			job[i].starttime=job[i].cometime;
		else
			job[i].starttime=t;
		job[i].endtime=timeAdd(job[i].starttime,job[i].runtime);
		job[i].running=true;
		job[i].cycletime=timeMinu(job[i].endtime,job[i].cometime);
	    job[i].weight_ctime=job[i].cycletime*1.0/job[i].runtime;
		T+=job[i].cycletime;
	    W+=job[i].weight_ctime;
		t=job[i].endtime;
	}
}


int HighReact(Job job[], int& n, time& t) //�ҳ���ҵ�����ȵ���
{
	int min = -1;
	for (int i = 0; i < n; i++)
	{
		if (job[i].running == false && compare(t, job[i].cometime) == true)
		{
			job[i].waittime = timeMinu(t, job[i].cometime);
			min = i;
			break;
		}
	}
	for (int j = min + 1; j < n; j++)
	{
		job[j].waittime = timeMinu(t, job[j].cometime);
		if (job[j].running == false && compare(t, job[j].cometime) == true && (double(job[j].runtime+job[j].waittime)/job[j].runtime)> (double(job[min].runtime + job[min].waittime) / job[min].runtime))//�Ƚ���Ӧ�ȣ����ߵ�����
			min = j;
	}
	return min;
}
void HIGH(Job job[], int n)//��Ӧ�ȸ��������㷨
{
	struct time t;
	job[0].starttime.hour = job[0].cometime.hour;//��һ�����Ŀ϶�����
	job[0].starttime.minute = job[0].cometime.minute;
	job[0].endtime = timeAdd(job[0].starttime, job[0].runtime);
	job[0].running = true;
	job[0].cycletime = timeMinu(job[0].endtime, job[0].cometime);
	job[0].weight_ctime = job[0].cycletime * 1.0 / job[0].runtime;
	T += job[0].cycletime;
	W += job[0].weight_ctime;
	t = job[0].endtime;
	while (HighReact(job, n,t) != -1)//ֱ�����е���ҵ�����Ϊֹ
	{
		int i = HighReact(job, n, t);//�ҵ�Ŀǰδ����ҵ�������Ӧ�ȵ�
		if (compare(job[i].cometime, t))//�Ƚϵ���ʱ�����һ��������ҵ�Ľ���ʱ��
			job[i].starttime = job[i].cometime;
		else
			job[i].starttime = t;
		job[i].endtime = timeAdd(job[i].starttime, job[i].runtime);
		job[i].running = true;
		job[i].cycletime = timeMinu(job[i].endtime, job[i].cometime);
		job[i].weight_ctime = job[i].cycletime * 1.0 / job[i].runtime;
		T += job[i].cycletime;
		W += job[i].weight_ctime;
		t = job[i].endtime;
	}
}

void main()
{
	//cout<<"��������ҵ����";
	int n;   //��ҵ��
	//cin>>n;
	n = 5;
	Job *job=new Job[n];
	
		Input(job,n);
		cout<<endl;
		FCFS(job,n);
		cout<<"�����ȷ���"<<endl;
		Result(job,n);
		cout<<endl;
		Init(job,n);
		SJF(job,n); //����ҵ����
		cout<<"����ҵ���ȣ�"<<endl;
		Result(job,n);
		cout << endl;
		Init(job, n);
		HIGH(job, n);
		cout << "����Ӧ�ȣ�" << endl;
		Result(job, n);
	
}