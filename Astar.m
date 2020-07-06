global M Wall Road Start End open open_count close close_count map_maze;
M = 10;
Wall = 3;%�ϰ���
Road = 0;%ͬ��
Start = 2;%���
End = 1;%�յ�

%�����ṹ�壻
node = {};
node.x = 0;
node.y = 0;
node.style = 0;%��ʾ�ýڵ����ϰ������·��
node.g = 0;
node.h = 0;
node.in_close = 0;
node.in_open = 0;
node.parent = [];%��¼���Ǹ��ڵ������

map_maze = node;%�����ڵ�����
map_maze(M,M).x = 10;
open = node;%����open�б�
open(1,M*M).x = 10;
open_count = 0;%��������open��Ԫ�ظ���
close = node;%����close�б�
close(1,M*M).x = 10;
close_count = 0;%��������close��Ԫ�ظ���
path_stack = [];%��������·��
top = 0;

%���г�ʼ��
is_found = 0;
maze = [2 0 0 3 0 3 0 0 0 0;
        0 0 3 0 0 3 0 3 0 3;
        3 0 0 0 0 3 3 3 0 3;
        3 0 3 0 0 0 0 0 0 3;
        3 0 0 0 0 3 0 0 0 3;
        3 0 0 3 0 0 0 3 3 3;
        3 0 0 0 0 3 3 0 0 0;
        0 0 0 0 0 0 0 0 0 0;
        3 3 3 0 0 3 0 3 3 0;
        3 0 0 0 0 3 3 3 0 1;];%Ϊ�˷����map_maze��ֵ
%��ÿ���ڵ㸳ֵ,���г�ʼ��
sx = 0;sy = 0;ex = 0;ey = 0;%������¼��ʼ�ڵ�������ڵ�
for x = 1:M
    for y = 1:M
        map_maze(x,y).x = x;
        map_maze(x,y).y = y;
        map_maze(x,y).g = 0;
        map_maze(x,y).h = 0;
        map_maze(x,y).in_close = 0;
        map_maze(x,y).in_open = 0;
        map_maze(x,y).style = maze(x,y);
        map_maze(x,y).parent = [];
        if (maze(x,y) == Start)
            sx = x;
            sy = y;
        end
        if (maze(x,y) == End)
            ex = x;ey = y;
        end
    end
end
for x = 1:M
    for y = 1:M
        map_maze(x,y).g = 1;
        map_maze(x,y).h = get_h(x,y,ex,ey);
    end
end
%ʹ��A*�㷨�ĵ�·��
open_add(map_maze(sx,sy));

map_maze(sx,sy).g = 0;
map_maze(sx,sy).h = get_h(sx,sy,ex,ey);
map_maze(sx,sy).parent = [];

is_found = 0;
while(1)
    cur_node = get_min();
    close_add(cur_node);
    if(cur_node.x == ex && cur_node.y == ey)%�ýڵ���Ŀ��ڵ�
        is_found = 1;
        break;
    end
    get_neighbors(cur_node,ex,ey);
    if (open_count == 0)%open���ѿգ�����û�ҵ����ڣ����ڲ�����
        is_found = 0;
        break;
    end
end
fprintf('the start point is: (%d,%d)\n',sx,sy);
fprintf('the end point is: (%d,%d)\n',ex,ey);
if (is_found == 1)
    path_stack = [cur_node.x,cur_node.y];
    while(~isempty(cur_node.parent))
       top = top + 1;
       path_stack = [path_stack;cur_node.parent];
       px = cur_node.parent(1);
       py = cur_node.parent(2);
       cur_node = map_maze(px,py);
    end
    fprintf('the way to the end\n')
    fprintf('(%d,%d)',sx,sy);
    while(top>0)
        cur_node = map_maze(path_stack(top,1),path_stack(top,2));
        fprintf('->(%d,%d)',cur_node.x,cur_node.y);
        top = top - 1;
    end
    fprintf('\n');
else
   fprintf('no way to the end\n') 
end

function get_neighbors(node,ex,ey)%�Խڵ���ھӽ��д�������ӵ�open�б���
global M;
x = node.x;
y = node.y;
if((y-1>=1)&&(y-1)<=M&&(x>=1)&&(x<=M))%�Ϸ��ڵ�
    insert_open(x,y-1,node,ex,ey,1);
end
if((y+1>=1)&&(y+1)<=M&&(x>=1)&&(x<=M))%�·��ڵ�
    insert_open(x,y+1,node,ex,ey,1);
end
if((x-1>=1)&&(x-1)<=M&&(y>=1)&&(y<=M))%�󷽽ڵ�
    insert_open(x-1,y,node,ex,ey,1);
end
if((x+1>=1)&&(x+1)<=M&&(y>=1)&&(y<=M))%�Ϸ��ڵ�
    insert_open(x+1,y,node,ex,ey,1);
end
end

function insert_open(x,y,cur,ex,ey,w)
global Wall map_maze;
if (map_maze(x,y).style ~= Wall)%�ڵ㲻���ϰ���
    if (map_maze(x,y).in_close == 0)%�ڵ㲻��close����
        if (map_maze(x,y).in_open == 1)%�ڵ���open����
            if(map_maze(x,y).g > cur.g + w)%�жϽڵ��Ƿ���Ҫ�޸�gֵ�����Ƿ���Ҫ�Ż�
                map_maze(x,y).g = cur.g + w;
                map_maze(x,y).parent = [cur.x cur y];
            end
        else%�ڵ㲻��open����
            map_maze(x,y).g = cur.g + w;%���ýڵ��gֵ
            map_maze(x,y).h = get_h(x,y,ex,ey);%����hֵ
            map_maze(x,y).parent = [cur.x,cur.y];%��¼�¸��ڵ������
            open_add(map_maze(x,y));%���ڵ���뵽open��
        end
    end
end
end
function h = get_h(cx,cy,ex,ey)%���������پ���õ�hֵ
h = abs(cx - ex) + abs(cy - ey);
end

function node = get_min()%���open��fֵ��С�Ľڵ�,�������open��ɾ��
global open open_count;
if (open_count <= 0)
    disp('the open list is empty, cannot get the min')
    return
end
f = [];
for i = 1:open_count
    fz = open(i).g + open(i).h;
    f = [f,fz];
end
m = find(f == min(f), 1, 'last' );
node = open(m);
open = [open(1:m-1),open(m+1:end)];
open_count = open_count - 1;
end

function open_add(node)%���ڵ���ӵ�open�еĺ���
global open open_count map_maze;
open_count = open_count + 1;
open(open_count) = node;
x = node.x;
y = node.y;
map_maze(x,y).in_open = 1;
end

function close_add(node)%���ڵ���ӵ�close��
global close close_count map_maze;
close_count = close_count + 1;
close(close_count) = node;
x = node.x;
y = node.y;
map_maze(x,y).in_close = 1;
end