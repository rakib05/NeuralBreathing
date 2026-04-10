function [Pxx,Freq] = plotPSD(Data,Fs,winL,PowerPlot,Nfft,plotfig,varargin)
%  [Pxx,Freq] = plotPSD(Data,Fs,winL,PowerPlot,Nfft,plotfig,varargin)
% winL-> window length in number of seconds (Default winL = 2)
% number of fft default Nfft = 2^nextpow2(winSamp);
% Pxx-> FFT (PowerPlot=0) or Power (PowerPlot=1)
if nargin<3 || isempty(winL)
    winL = 2; % Default window length 2 sec
end
if nargin<4 || isempty(PowerPlot)
    PowerPlot = 1;
end
if nargin<6 || isempty(plotfig)
    plotfig = 'yes';
end
if nargin < 7 || isempty(varargin)
    varargin{1} = 'Linewidth';
    varargin{2} = 0.5;
end

winSamp = floor(winL*Fs); Overlap = floor(0.8*winSamp); 
if nargin<5 || isempty(Nfft); Nfft = 2^nextpow2(winSamp);  end

[pxx,freq]=pwelch(Data,winSamp,Overlap,Nfft,Fs,'onesided');
if strcmp(plotfig,'yes')
    if PowerPlot ==1
        plot(freq, 20*log10(pxx),varargin{1},varargin{2});
        ylabel('Power/Frequency (dB/Hz)');
    else
        plot(freq,zscore(pxx),varargin{1},varargin{2});
        ylabel('FFT (/Hz)');
    end
    grid on; grid minor;
    set(gcf,'color','w');
    xlabel('Frequency (Hz)')
end

if nargout<1
    return;
end

if PowerPlot ==1
    Pxx = 20*log10(pxx);
else
    Pxx = pxx;
end
Freq = freq;
end