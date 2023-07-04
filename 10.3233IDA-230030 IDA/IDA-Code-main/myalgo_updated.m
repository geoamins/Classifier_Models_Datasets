function [myalgo_updated]= myalgo_updated(adj,beta_val,spaths)


All_ShortestPaths = ASP(adj); %shortest path
myalgo_updated    = MostVisited_node_similarities(adj, 0.007, All_ShortestPaths);% Sum up both feature similarities
end