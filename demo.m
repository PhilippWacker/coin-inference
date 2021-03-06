clear();
nbits = 3;	% number of memory bits
NSim = 10000;	% number of Monte Carlo simulations

inp = input("input random string: ", "s");
% process string to number array
for k=1:length(inp)
A(k) = str2num(inp(k));
end

%A = unidrnd(2, 1, 150)-1;

N = length(A);	% length of input
K = N-sum(A);	% number of 0s

% A_proc contains every sequence of [nbits] bits memory, one at each row
% A_next contains the subsequent element for every sequence, i.e. for 
% A = ... 0 1 0 0 1 ..., there is a row 1 0 0 in A_proc and an element 1 in A_next at the same index

% these variables help to quicker calculate likelihoods and such.

% Example of A, A_proc and A_next for nbits=3:
% A = 1 0 1 1 1 0
% A_proc = 	1 0 1
%		0 1 1
%		1 1 1
%	
% A_next = 	1
%		1
%		0	


% process A to have all nbits-tupels in rows, save in A_proc
A_proc = zeros(length(A)-nbits, nbits);
for k=1:size(A_proc, 1)
A_proc(k, :) = A(k:k+nbits-1);
end;
% next-step-results (fitting A_proc)
A_next = A(nbits+1:end)';


% get Markov parameters
pars = getParamsMarkov(A_proc, A_next);

% now compare the logarithmic likelihoods of all hypotheses:
% we calculate everything in logarithmic quantities to avoid rounding off errors
logprob(1) = (N)*log(0.5);
sumterms1 = [1:(N+1)];		% ignore first nbits bits
sumterms2 = [1:(K),1:(N-K)];	% ignore first nbits bits
logprob(2) = sum(-log(sumterms1))+sum(log(sumterms2));
logprob(3) = probAMarkov(A(1:min(nbits, end)), A_proc, A_next, NSim);

prob = exp(logprob);
prob = prob/sum(prob);

displayResult(prob, pars, K/N, nbits);

% sample fair coin: 11110000100001010100100001011010111101101011001000
% sample bent coin (p = 0.6): 11110101100100001111011100000101111111000101111111111011100110010101010100111100
% longer sample bent coin: 110101111001101110101011011011000010101111111110111111111100101011011100101100111010110110010101011001100011111111111110111110011000011111110001110000100100001010101000011001000110
