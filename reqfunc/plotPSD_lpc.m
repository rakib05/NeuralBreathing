function [Pxx,Freq] = plotPSD_lpc(Data,Fs,NumCoeff,PowerPlot,plotfig,Nfft,varargin)
%Computes PSD using Linear Predictor Coefficients (lpc.m)
%[Pxx,Freq] = plotPSD_lpc(Data,Fs,NumCoeff,PowerPlot,plotfig,varargin)
%  Pxx-> FFT (PowerPlot=0) or Power (PowerPlot=1)
%  NumCoeff --> order of lpc/number of linear predictors (default = 2*Fs)
if nargin<3 || isempty(NumCoeff); NumCoeff = 2*Fs;end
if nargin<4 || isempty(PowerPlot); PowerPlot = 1;end
if nargin<5 || isempty(plotfig)
    plotfig = 'yes';
end
if nargin<6 || isempty(Nfft); Nfft =  2^18;end
if nargin < 7 || isempty(varargin)
    varargin{1} = 'Linewidth';
    varargin{2} = 0.5;
end

[lpcData,P] = lpc(Data,NumCoeff);
lpcDft = fft(lpcData',Nfft);
lpcDft = lpcDft./sqrt(P');
lpcDft = 1./abs(lpcDft(1:Nfft/2+1,:));
ff = (0:Nfft/2)./Nfft;
freq = ff*Fs; 
if strcmp(plotfig,'yes')
    if PowerPlot ==1
        plot(freq, 20*log10(lpcDft),varargin{1},varargin{2});
        ylabel('PSD (dB/Hz)');
    else
        plot(freq,lpcDft./max(lpcDft),varargin{1},varargin{2});
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
    Pxx = 10*log10(lpcDft);
else
    Pxx = lpcDft./max(lpcDft);
end
Freq = freq;
end