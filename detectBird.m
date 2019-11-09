function detectBird()
load('birdsProfiles.mat');

[FileName,PathName,~] = uigetfile({'*.wav';'*.mat'},'Choose Recording...');
wavFile = audioread([PathName,FileName]);
calls = extractCalls(wavFile);
c = length(calls);

sample(c).mfccs = 0;     
for i=1:c
    sample(i).mfccs = getMFCCs(calls(i).call);    %Generate MFCCs
end

%Compare sample MFCCs with birds profiles MFCCs
b = length(birdsProfiles.birds);
A = zeros(c,b);
for i=1:b
    y=0;
    eval(['y = birdsProfiles.' char(birdsProfiles.birds(i)) '.mfccs,']);
    for j=1:c %call sample number
        x = sample(j).mfccs;
        p = [min(size(x,1),size(y,1)) min(size(x,2),size(y,2))];
        similarity = compareMFCCs(x(1:p(1),1:p(2)),y(1:p(1),1:p(2)));
        if(similarity==Inf)
            A(j,i) = 10^3;
        else
            A(j,i) = similarity;
        end
    end
end


Av = mean(A);   %Compute vector of averages for each bird
answer.index = find(Av == min(Av));  
answer.code=birdsProfiles.birds(answer.index);

%Set the display
createDisplay(600,500);
eval(['answer.image = birdsProfiles.' char(answer.code) '.picture;']);
image(answer.image); axis off;
answer.text.y = max(size(answer.image,1))+2;
answer.text.x = max(size(answer.image,2))/2;
answer.text.birdname.latin = '';

eval(['answer.text.birdname.latin = birdsProfiles.' char(answer.code) '.name.latin;']);

text(answer.text.x,answer.text.y,char(answer.text.birdname.latin),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',18,'FontName','Myriad Pro','BackGroundColor',[0 .251 .4235],'Color',[.9725 .2863 .2863]);