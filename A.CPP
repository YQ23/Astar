#include <stdio.h>
#include <math.h>
#define map_length 51
#define map_width 51
void main()
{
	int data[map_length][map_width] = {0};
	int i,j;

	// set up the occupancy grid
	for(i=1;i<=5;i++)
	{
		for(j=1;j<=4;j++)
			data[i][j] = 1;
	}

    for(i=14;i<=17;i++)
	{
		for(j=1;j<=5;j++)
			data[i][j] = 1;
	}

	for(i=1;i<=5;i++)
	{
		for(j=29;j<=39;j++)
        	data[i][j] = 1;
	}

	// set up the origin and destination
	int start_node[2] = {0,0};
	int end_node[2] = {15,6};

	// set up all the data that is needed
	int bignumber = 100;

	// 1: Heuristic function (h-value)
	int H[map_length][map_width] = {0};
	for(i=0;i<map_length;i++)
	{
		for(j=0;j<map_length;j++)
		{
			if(data[i][j] == 1)
			{
				H[i][j] = bignumber;
			}
			else
			{
				H[i][j] = abs(i-end_node[0]) + abs(j-end_node[1]);
			}
		}
	}

	// 2: Cost function (g-value) set to be infinite numbers first
	int G[map_length][map_width];
	for(i=0;i<map_length;i++)
	{	
		for(j=0;j<map_width;j++)
			G[i][j] = bignumber;
	}
	G[start_node[0]][start_node[1]] = 0;

	// 3: F function which is G+H
	int F[map_length][map_width];
	for(i=0;i<map_length;i++)
	{	
		for(j=0;j<map_width;j++)
			F[i][j] = bignumber;
	}

	// 4: Open Set (the set of points being evaluated (neighbors around the closed set))
	int Open[map_length][map_width] = {0};

	// 5: Closed Set (the set of points that have been selected for calculation)
	int Close[map_length][map_width] = {0};
	Close[start_node[0]][start_node[1]] = 1;

	// 6: parent set (P1 is the first, P2 is the second index (we don't fully index the node))
	int P1[map_length][map_width] = {0};
	int P2[map_length][map_width] = {0};

	// Start the A* algorithm
	// loop
	// 1.start with newly added closed set point
	i = start_node[0];
	j = start_node[1];

	while(abs(i-end_node[0])+abs(j-end_node[1])!=0)
	{
		Close[i][j] = 1;
		Open[i][j] = 0;
		F[i][j] = bignumber;
		// 2. put the neighbors of closed set point (not the obstacle) into open
		// set, update parent , G-value and F-value
		if(i+1<map_length)
		{
		    if(data[i+1][j] == 0)
			{
				Open[i+1][j] = 1;
				if(1+G[i][j]<G[i+1][j])
					//we change
				{
					G[i+1][j] = 1+G[i][j];
					P1[i+1][j] = i;
					P2[i+1][j] = j;
					F[i+1][j] = G[i+1][j] + H[i+1][j];
				}
			}
			
		}

		if(i-1>0)
		{
			if(data[i-1][j] == 0)
			{
				Open[i-1][j] = 1;
				if(1+G[i][j]<G[i-1][j])
					//we change
				{
					G[i-1][j] = 1+G[i][j];
					P1[i-1][j] = i;
					P2[i-1][j] = j;
					F[i-1][j] = G[i-1][j] + H[i-1][j];
				}
			}
			
		}

		if(j+1<map_width)
		{
			if(data[i][j+1] == 0)
			{
				Open[i][j+1] = 1;
				if(1+G[i][j]<G[i][j+1])
					//we change
				{
					G[i][j+1] = 1+G[i][j];
					P1[i][j+1] = i;
					P2[i][j+1] = j;
					F[i][j+1] = G[i][j+1] + H[i][j+1];
				}
			}
		}

		if(j-1>0)
		{
			if(data[i][j-1] == 0)
			{
				Open[i][j-1] = 1;
				if(1+G[i][j]<G[i][j-1])
					//we change
				{
					G[i][j-1] = 1+G[i][j];
					P1[i][j-1] = i;
					P2[i][j-1] = j;
					F[i][j-1] = G[i][j-1] + H[i][j-1];
				}
			}
		}

	

	int index1,index2;
	int min=F[0][0];
	for(i=0;i<map_length;i++)
		for(j=0;j<map_width;j++)
		{	
			if(F[i][j]<min)
			{
				min = F[i][j];
				index1 = i;
				index2 = j;
			}
		}
	i = index1;
	j = index2;

	}
	printf("i=%d,j=%d\n",i,j);
}
