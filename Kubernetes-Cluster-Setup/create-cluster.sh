eksctl create cluster \
--name todo-cluster \
--version  1.30 \
--region ap-south-1 \
--nodegroup-name linux-nodes \ 
--node-type t2.micro \
--nodes 2