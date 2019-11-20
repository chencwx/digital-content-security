#include <iostream>
#include <string>
using namespace std;
#pragma warning(disable : 4996)
struct time //时间的数据结构
{
	int hour;
	int minute;
};

struct Job //作业
{
	int num;//作业序号
	string jobname;   //作业名
	time cometime;      //进入时间
	int runtime;      //作业估计运行时间
	time starttime;   //作业开始时间
	time endtime;     //作业结束时间
	int cycletime;    //作业周转时间
	int waittime;//等待时间
    float weight_ctime;     //作业带权周转时间=作业周转时间/作业运行时间
	bool running;      //是否已运行
};

double T=0;//作业平均周转时间
double W=0;//作业带权平均周转时间

void Input(Job job[],int &n)  //输入作业信息
{
	cout<<"**********请按作业进入时间先后顺序输入*********"<<endl;
	cout << "作业序号" << "\t" << "作业名称" << "\t" << "作业开始时间" << "\t" << "作业要求运行时间" << "\t" << endl;
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
		job[i].running=false; //标记为未运行
		cout<<"*********************"<<endl;
	}
}

void Init(Job job[],int &n)//初始化
{
	for(int i=0;i<n;i++)
	{
		job[i].starttime.hour=0;
		job[i].starttime.minute=0;
		job[i].endtime.hour=0;
		job[i].endtime.minute=0;
		job[i].cycletime=0;
		job[i].weight_ctime=0;
		job[i].running=false; //标记为未运行
	}
	T=0;
	W=0;
}

void Displaytime(time time)    //显示时间
{
	cout<<time.hour<<":"<<time.minute;
}
int timeMinu(time t1,time t2)  //计算时间差,时间t1比t2大
{
	return t1.hour*60+t1.minute-(t2.hour*60+t2.minute);
}
time timeAdd(time time,int addtime) //时间相加
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
bool compare(time t1,time t2)//比较两个时间的大小，第一个大就返回TRUE
{
	if(t1.hour>t2.hour)
		return true;
	else if(t1.hour==t2.hour&&t1.minute>=t2.minute)
		return true;
	else
		return false;
}

void Result(Job job[],int &n)  //显示结果
{
	cout<<"jobnum\tjobname\tcometime\truntime\tsttime\tendtime\t等待时间\t周转时间(分钟)\t带权周转时间"<<endl;
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
	cout<<"作业平均周转时间：T="<<T/(n*1.0)<<endl;
	cout<<"作业带权平均周转时间：W="<<W/(n*1.0)<<endl;
}

int minRuntime(Job job[],int &n,time &t) //找出作业中最短作业下标
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

void SJF(Job job[],int &n)//短作业优先作业调度
{
	struct time t;
	job[0].starttime.hour=job[0].cometime.hour;//第一个到达的要先做
	job[0].starttime.minute=job[0].cometime.minute;
	job[0].endtime=timeAdd(job[0].starttime,job[0].runtime);
	job[0].running=true;
	job[0].cycletime=timeMinu(job[0].endtime,job[0].cometime);
	job[0].weight_ctime=job[0].cycletime*1.0/job[0].runtime;
	T+=job[0].cycletime;//用于计算平均周转时间
	W+=job[0].weight_ctime;//计算评价加权周转时间
	t=job[0].endtime;
	while(minRuntime(job,n,t)!=-1)
	{
		int i=minRuntime(job,n,t);//找到目前未做的队列中运行时间最短的
		if(compare(job[i].cometime,t))//到达时间与上一个结束时间相比
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

int Firstcometime(Job job[],int &n) //找出作业中最先到的
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
		if(job[j].running==false && compare(job[min].cometime,job[j].cometime))//比较更大的时间，即更晚
			min=j;
	return min;
}
void FCFS(Job job[],int &n)//先来先服务作业调度
{
	struct time t;
	job[0].starttime.hour=job[0].cometime.hour;//第一个到的肯定先做
	job[0].starttime.minute=job[0].cometime.minute;
	job[0].endtime=timeAdd(job[0].starttime,job[0].runtime);
	job[0].running=true;
	job[0].cycletime=timeMinu(job[0].endtime,job[0].cometime);
	job[0].weight_ctime=job[0].cycletime*1.0/job[0].runtime;
	T+=job[0].cycletime;
	W+=job[0].weight_ctime;
	t=job[0].endtime;
	while(Firstcometime(job,n)!=-1)//直到所有的作业都完成为止
	{
		int i=Firstcometime(job,n);//找到目前未做作业中最先到达的
		if(compare(job[i].cometime,t))//比较到达时间和上一个到达作业的结束时间
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


int HighReact(Job job[], int& n, time& t) //找出作业中最先到的
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
		if (job[j].running == false && compare(t, job[j].cometime) == true && (double(job[j].runtime+job[j].waittime)/job[j].runtime)> (double(job[min].runtime + job[min].waittime) / job[min].runtime))//比较响应比，更高的优先
			min = j;
	}
	return min;
}
void HIGH(Job job[], int n)//响应比高者优先算法
{
	struct time t;
	job[0].starttime.hour = job[0].cometime.hour;//第一个到的肯定先做
	job[0].starttime.minute = job[0].cometime.minute;
	job[0].endtime = timeAdd(job[0].starttime, job[0].runtime);
	job[0].running = true;
	job[0].cycletime = timeMinu(job[0].endtime, job[0].cometime);
	job[0].weight_ctime = job[0].cycletime * 1.0 / job[0].runtime;
	T += job[0].cycletime;
	W += job[0].weight_ctime;
	t = job[0].endtime;
	while (HighReact(job, n,t) != -1)//直到所有的作业都完成为止
	{
		int i = HighReact(job, n, t);//找到目前未做作业中最高响应比的
		if (compare(job[i].cometime, t))//比较到达时间和上一个到达作业的结束时间
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
	//cout<<"请输入作业数：";
	int n;   //作业数
	//cin>>n;
	n = 5;
	Job *job=new Job[n];
	
		Input(job,n);
		cout<<endl;
		FCFS(job,n);
		cout<<"先来先服务："<<endl;
		Result(job,n);
		cout<<endl;
		Init(job,n);
		SJF(job,n); //短作业优先
		cout<<"短作业优先："<<endl;
		Result(job,n);
		cout << endl;
		Init(job, n);
		HIGH(job, n);
		cout << "高响应比：" << endl;
		Result(job, n);
	
}