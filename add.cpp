#include<bits/stdc++.h>
using namespace std;
int main(){
	string x,op;
	bool fin = false;
	int valor,sum=0,temp=0;
	string aux;
	map<string,int> valores;
	map<int,string> resp;
	while(!cin.eof()){
		cin>>x;
		if(x == "def"){
			cin>>x>>valor;
			valores[x]=valor;
			resp[valor]=x;
		}
		else if(x == "calc"){
			fin = false;
			op.clear();
			sum =  temp=0;
			cin>>x;
			if(valores.find(x)!=valores.end()) sum = valores[x];
			else fin = true;
			op+=x;
			string opAnte="";
			while(true){
				cin>>x;
				op+=x;
				if(x=="=" )break;
				if(x=="+" ){
					opAnte="+";
				}
				else if(x == "-"){
					opAnte="-";
				}else if(valores.find(x)!=valores.end()){
					temp = valores[x];
					if(opAnte=="+" ){
						sum+=temp;
					}
					else if(opAnte == "-"){
						sum-=temp;
					}
				}else{
					fin = true;
				}

				temp = 0;
			}

			for(map<string,int>::iterator it=valores.begin();it!=valores.end();it++) cout<<it->first<<' ';
			printf("sum \n%d\n ",sum);
			op+=" = ";
			cout<<op;
			if(fin) cout<<"unknown"<<endl;
			else if(resp.find(sum)!=resp.end()) cout<<resp[sum];
			else cout<<"unknown"<<endl;
			fin = false;
			sum = 0;
		}
		else{
			valores.clear();
			resp.clear();
		}

	}

	return 0;
}

