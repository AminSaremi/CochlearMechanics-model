function c = conv_fft(a,b,shape)
% Convolve two vectors using FFT multiplication
% 
%   c = conv_fft(a,b)
%   c = conv_fft(a,b,shape)
% 
%   Convolution using traditional overlapping methods can be
%   slow for very long signals. A more efficient method is
%   to multiply the FFTs of the signals and take the inverse
%   FFT of the result. However, this comes at a cost:
%   FFT-based convolution is subject to floating-point
%   round-off errors, and requires more memory [1].
% 
%   c = conv_fft(a,b) convolves vectors a and b. The
%   resulting vector is length: length(a)+length(b)-1.
% 
%   c = conv_fft(a,b,shape) returns a subsection of the
%   convolution with size specified by shape:
%     'full'  - (default) returns the full convolution,
%     'same'  - returns the central part of the convolution
%               that is the same size as a.
%     'valid' - returns only those parts of the convolution
%               that are computed without the zero-padded
%               edges. length(c) is L-2*(min(P,Q)-1) where
%               P = numel(a), Q = numel(b), L = P+Q-1.
% 
%   Based on code written by Steve Eddins, 2009.
%   
%   References
% 
%   [1] http://blogs.mathworks.com/steve/2009/11/03/
%       the-conv-function-and-implementation-tradeoffs/
% 
%   See also CONV.

% !---
% ==========================================================
% Last changed:     $Date: 2012-10-28 13:03:43 +0000 (Sun, 28 Oct 2012) $
% Last committed:   $Revision: 214 $
% Last changed by:  $Author: ch0022 $
% ==========================================================
% !---

assert(isvector(a) & isvector(b),'a and b must be vectors')

if nargin<3
    shape = 'full';
end
assert(ischar(shape),'Unknown shape parameter')

P = numel(a);
Q = numel(b);
L = P + Q - 1;
K = 2^nextpow2(L);

% do the convolution
afft = fft(a, K);
bfft = fft(b, K);
c = ifft(afft(:).*bfft(:));

% specify index range for shape
switch lower(shape)
    case 'full'
        range = [1, L];
    case 'same'
        range = [floor(length(b)/2)+1, L-ceil(length(b)/2)+1];
    case 'valid'
        range = [min(P,Q), L-min(P,Q)+1];
    otherwise
        error(['shape ''' shape ''' is invalid. The options are ''full'' (default), ''same'', or ''valid''.'])
end

% crop to shape
c = c(range(1):range(2));

% restore orientation
if shape(1) == 'f'
    if length(a) > length(b)
        if size(a,1) == 1 %row vector
            c = c.';
        end
    else
        if size(b,1) == 1 %row vector
            c = c.';
        end
    end
else
    if size(a,1) == 1 %row vector
        c = c.';
    end
end

% [EOF]