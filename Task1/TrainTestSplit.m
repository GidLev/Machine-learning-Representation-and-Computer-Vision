function [Data1, Data2, Labels1, Labels2, Data1Indices, Data2Indices] = ...
    TrainTestSplit(Data, Labels, Params)
%TrainTestSplit Randomly Splits the data and labels according to a ratio defined in Params
%We ensure that the data is splitted by labels, so Ratio will remain whithin label

%{
    n = size(Data, 3);
    perm = randperm(n); %choose random permutation
    
    Data1Indices = perm(1:ceil(n*(1-Params.Ratio)));
    Data1 = Data(:,:,Data1Indices);
    Labels1 = Labels(Data1Indices);
    
    Data2Indices = perm(length(Data1Indices)+1:end);
    Data2 = Data(:,:,Data2Indices);
    Labels2 = Labels(Data2Indices);
%}

%Store original order
Indices = 1:length(Labels);

%shuffle original data
perm = randperm(length(Labels));

Labels = Labels(perm);
Data = Data(:,:,perm);
Indices = Indices(perm);

AssingVec = zeros(1, length(Labels));
for Catgor = unique(Labels) % loop over each category
    % create boolean vector for catagory
    CatgorLoc = zeros(1, length(Labels));
    CatgorLoc(Labels == Catgor) = 1;
    % Create vector for train/test
    TrainOrTest = ones(1, sum(CatgorLoc));
    TrainOrTest(1:round(sum(CatgorLoc) * Params.Ratio)) = 2;
    TrainOrTest = TrainOrTest(randperm(length(TrainOrTest)));
    CatgorLoc(CatgorLoc == 1) = TrainOrTest;
    % add to one vector for all
    AssingVec = AssingVec + CatgorLoc;
end

% Assign data to train/test
Data1 = Data(:,:,AssingVec == 1);
Data2 = Data(:,:,AssingVec == 2);
Labels1 = Labels(AssingVec == 1);
Labels2 = Labels(AssingVec == 2);

Data1Indices = Indices(AssingVec == 1);
Data2Indices = Indices(AssingVec == 2);
end


