% Multivariate Linear Regression
clear;
close all;
clc;

% Step_1: Loading the dataset

data = load ('ex1data2.txt');
X = data (:, 1:2);
y = data (:, 3);
m = length(y); 

% Step_2: Feature scaling

function [X_norm, mu, sigma] = featureNormalize (X)
  X_norm = X;
  mu = zeros (1, size (X, 2));
  sigma = zeros (1, size (X, 2)); 
  
  for i = 1 : size (X, 2)
    mu (i) = mean (X (:, i));
    sigma (i)= std (X (:, i));
    X_norm (:, i) = (X(:, i) - mu(i) )/ sigma (i); 
  end 
 
end 
  
[X mu sigma] = featureNormalize (X);

% Step_3: Adding column of 1 as the corresponding term for theta_0 (as intercept)
X = [ones(m, 1) X]; 

% Step_4: GD
alpha_1 = 0.01;
num_iters = 400;
theta = zeros(3, 1);

function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
m = length(y); 
J_history = zeros(num_iters, 1);

  for iter = 1:num_iters
    for j = 1: size (X, 2)
    term (j) = (alpha / m) * sum (((X * theta) - y) .* X(:,j));

    end

   for j = 1: size (X, 2)
   theta(j,1) = theta(j,1) - term (j); 

   end   
    J_history(iter) = computeCostMulti(X, y, theta);

  end

end

[theta, J_history_1] = gradientDescentMulti(X, y, theta, alpha_1, num_iters);


% Step_5: Plotting the convergence graph
figure;
plot(1:numel(J_history_1), J_history_1, '-b', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Cost J');


hold on
alpha_2 = 0.03
theta = zeros(3, 1);
[theta, J_history] = gradientDescentMulti(X, y, theta, alpha_2, num_iters);
plot(1:numel(J_history), J_history, '-r', 'LineWidth', 2);

alpha_3 = 0.1
theta = zeros(3, 1);
[theta, J_history] = gradientDescentMulti(X, y, theta, alpha_3, num_iters);
plot(1:numel(J_history), J_history, '-k', 'LineWidth', 2);

% Step_6: Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');

% Step_7: Prediction
X_pred = [1 1650 3];
X_pred (1,2) = (X_pred (1,2) - mu(1,1))/ sigma (1,1);
X_pred(1,3) = (X_pred(1,3) - mu(1,2))/ sigma(1,2); 
price = X_pred * theta;
fprintf(['Predicted price of a 1650 sq-ft, 3 br house ' ...
         '(using gradient descent):\n $%f\n'], price);

% Step_8: Normal equation
data = csvread('ex1data2.txt');
X = data(:, 1:2);
y = data(:, 3);
m = length(y);

% Add intercept term to X
X = [ones(m, 1) X];
function [theta] = normalEqn(X, y)
theta = zeros(size(X, 2), 1);

theta = pinv(X' * X) * X' * y; 

end

theta = normalEqn(X, y);
fprintf('Theta computed from the normal equations: \n');
fprintf(' %f \n', theta);
fprintf('\n');

% Step_9: Prediction using Normal eq.
X_pred = [1 1650 3];
price = X_pred * theta; 

fprintf(['Predicted price of a 1650 sq-ft, 3 br house ' ...
         '(using normal equations):\n $%f\n'], price);
