function [distance,path]=Floyd1(W,st,e) %寻找i,j两点最短路径
% 输入：W—邻接矩阵，元素(Wij)是顶点i到j之间的直达距离，可以是有向的 
% st—起点的标号；e—终点的标号
% 输出：distance—最短路的距离；
% path—最短路的路径
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
parent=path(st,:);%从起点st到终点e的最短路上各顶点的前驱顶点 
parent(parent==0)=st; %path中的分量为0，表示该顶点的前驱是起点
path=e;
t=e;
while t~=st    
    p=parent(t);
    path=[p,path];  
    t=p;
end
end