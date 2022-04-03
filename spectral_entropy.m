%%
%   author: Trung Van
%   email: trung.van@tuni.fi
%
%%
function H = spectral_entropy(P,nfactor)
% SPECTRAL_ENTROPY: compute the spectral entropy from a given PSD and a (log) factor
% Normalization constant C_n
C_n = 1/sum(P);
% Normalized PSD
P_n = P * C_n;
% Spectral entropy corresponding to frequency range as a sum
S = sum(P_n .* log(1 ./ P_n));
% Normalized (with factor log) entropy value
S_N = S / nfactor;
H = S_N;% Only for naming coherrent
end