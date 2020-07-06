global M Wall Road Start End open open_count close close_count map_maze;
M = 10;
Wall = 3;%障碍物
Road = 0;%同理
Start = 2;%起点
End = 1;%终点

%创建结构体；
node = {};
node.x = 0;
node.y = 0;
node.style = 0;%表示该节点是障碍物，还是路径
node.g = 0;
node.h = 0;
node.in_close = 0;
node.in_open = 0;
node.parent = [];%记录的是父节点的坐标

map_maze = node;%创建节点数组
map_maze(M,M).x = 10;
open = node;%创建open列表
open(1,M*M).x = 10;
open_count = 0;%用来监视open中元素个数
close = node;%创建close列表
close(1,M*M).x = 10;
close_count = 0;%用来监视close中元素个数
path_stack = [];%用来保存路径
top = 0;

%进行初始化
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
        3 0 0 0 0 3 3 3 0 1;];%为了方便给map_maze赋值
%对每个节点赋值,进行初始化
sx = 0;sy = 0;ex = 0;ey = 0;%用来记录开始节点与结束节点
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
%使用A*算法的道路径
open_add(map_maze(sx,sy));

map_maze(sx,sy).g = 0;
map_maze(sx,sy).h = get_h(sx,sy,ex,ey);
map_maze(sx,sy).parent = [];

is_found = 0;
while(1)
    cur_node = get_min();
    close_add(cur_node);
    if(cur_node.x == ex && cur_node.y == ey)%该节点是目标节点
        is_found = 1;
        break;
    end
    get_neighbors(cur_node,ex,ey);
    if (open_count == 0)%open表已空，但还没找到出口，出口不存在
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

function get_neighbors(node,ex,ey)%对节点的邻居进行处理，将添加到open列表中
global M;
x = node.x;
y = node.y;
if((y-1>=1)&&(y-1)<=M&&(x>=1)&&(x<=M))%上方节点
    insert_open(x,y-1,node,ex,ey,1);
end
if((y+1>=1)&&(y+1)<=M&&(x>=1)&&(x<=M))%下方节点
    insert_open(x,y+1,node,ex,ey,1);
end
if((x-1>=1)&&(x-1)<=M&&(y>=1)&&(y<=M))%左方节点
    insert_open(x-1,y,node,ex,ey,1);
end
if((x+1>=1)&&(x+1)<=M&&(y>=1)&&(y<=M))%上方节点
    insert_open(x+1,y,node,ex,ey,1);
end
end

function insert_open(x,y,cur,ex,ey,w)
global Wall map_maze;
if (map_maze(x,y).style ~= Wall)%节点不是障碍物
    if (map_maze(x,y).in_close == 0)%节点不在close表中
        if (map_maze(x,y).in_open == 1)%节点在open表中
            if(map_maze(x,y).g > cur.g + w)%判断节点是否需要修改g值，即是否需要优化
                map_maze(x,y).g = cur.g + w;
                map_maze(x,y).parent = [cur.x cur y];
            end
        else%节点不在open表中
            map_maze(x,y).g = cur.g + w;%设置节点的g值
            map_maze(x,y).h = get_h(x,y,ex,ey);%设置h值
            map_maze(x,y).parent = [cur.x,cur.y];%记录下父节点的坐标
            open_add(map_maze(x,y));%将节点加入到open中
        end
    end
end
end
function h = get_h(cx,cy,ex,ey)%利用曼哈顿距离得到h值
h = abs(cx - ex) + abs(cy - ey);
end

function node = get_min()%获得open中f值最小的节点,并将其从open中删除
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

function open_add(node)%将节点添加到open中的函数
global open open_count map_maze;
open_count = open_count + 1;
open(open_count) = node;
x = node.x;
y = node.y;
map_maze(x,y).in_open = 1;
end

function close_add(node)%将节点添加到close中
global close close_count map_maze;
close_count = close_count + 1;
close(close_count) = node;
x = node.x;
y = node.y;
map_maze(x,y).in_close = 1;
end