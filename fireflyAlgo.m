clc;
clear;
close all;

%% Problem Definition

%CostFunction = @(x) process(x);        % Cost Function

nVar = 1;                 % Number of Decision Variables

VarSize = [1 nVar];       % Decision Variables Matrix Size

VarMin = 0;             % Decision Variables Lower Bound
VarMax = 1;             % Decision Variables Upper Bound

%% Firefly Algorithm Parameters

MaxIt = 1;         % Maximum Number of Iterations

nPop = 20;            % Number of Fireflies (Swarm Size)

gamma = 1;            % Light Absorption Coefficient

beta0 = 1;            % Attraction Coefficient Base Value

alpha = 0.2;          % Mutation Coefficient

alpha_damp = 0.98;    % Mutation Coefficient Damping Ratio

delta = 0.05*(VarMax-VarMin);     % Uniform Mutation Range

m = 2;

if isscalar(VarMin) && isscalar(VarMax)
    dmax = (VarMax-VarMin)*sqrt(nVar);
else
    dmax = norm(VarMax-VarMin);
end

%% Initialization

% Empty Firefly Structure
firefly.Cf = [];
firefly.Cost = [];

% Initialize Population Array
pop = repmat(firefly, nPop, 1);

% Initialize Best Solution Ever Found
BestSol.Cost = -inf;

% Create Initial Fireflies
for i = 1:nPop
   pop(i).Cf = unifrnd(VarMin, VarMax, VarSize);
   k = withFirefly(pop(i).Cf);
   pop(i).Cost = k(1);
   
   if pop(i).Cost >= BestSol.Cost
       BestSol = pop(i);
   end
end

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% Firefly Algorithm Main Loop
k = zeros(7);
for it = 1:MaxIt
    
    newpop = repmat(firefly, nPop, 1);
    for i = 1:nPop
        newpop(i).Cost = -inf;
        for j = 1:nPop
            if pop(j).Cost > pop(i).Cost
                rij = norm(pop(i).Cf-pop(j).Cf)/dmax;
                beta = beta0*exp(-gamma*rij^m);
                e = delta*unifrnd(-1, +1, VarSize);
                %e = delta*randn(VarSize);
                
                newsol.Cf = pop(i).Cf ...
                                + beta*rand(VarSize).*(pop(j).Cf-pop(i).Cf) ...
                                + alpha*e;
                
                newsol.Cf = max(newsol.Cf, VarMin);
                newsol.Cf = min(newsol.Cf, VarMax);
                
                [k, a, b, c, d, e, f, g] = withFirefly(newsol.Cf);
                newsol.Cost = k(1);
                
                if newsol.Cost >= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost >= BestSol.Cost
                        BestSol = newpop(i);
                    end
                end
                
            end
        end
    end
    
    % Merge
    pop = [pop
         newpop];  %#ok
    
    % Sort
    [~, SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Mutation Coefficient
    alpha = alpha*alpha_damp;
    
end

%% Results
% results order:
% 1. no attack, 2. median attack, 3. salt and pepper noise, 4. average attack, 
% 5. sharpen attack, 6. speckle noise
j = withoutFirefly();
x = [1, 2, 3, 4, 5, 6, 7];
k = [a, b, c, d, e, f, g];
disp(k);
plot(x, j, x, k)