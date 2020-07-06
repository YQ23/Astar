function [distance,path]=Floyd1(W,st,e) %Ѱ��i,j�������·��
% ���룺W���ڽӾ���Ԫ��(Wij)�Ƕ���i��j֮���ֱ����룬����������� 
% st�����ı�ţ�e���յ�ı��
% �����distance�����·�ľ��룻
% path�����·��·��
n=size(W,1);
path=zeros(n); 
for k=1:n    
    for i=1:n        
        for j=1:n          
            if W(i,j)>W(i,k)+W(k,j)           
                W(i,j)=W(i,k)+W(k,j);         
                path(i,j)=k;          
            end
        end
    end
end
distance=W(st,e);
parent=path(st,:);%�����st���յ�e�����·�ϸ������ǰ������ 
parent(parent==0)=st; %path�еķ���Ϊ0����ʾ�ö����ǰ�������
path=e;
t=e;
while t~=st    
    p=parent(t);
    path=[p,path];  
    t=p;
end
end