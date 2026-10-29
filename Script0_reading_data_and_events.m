%% subject1
clc;
clear;
% close all;
load ('block600') %%% block data
for subject = 3
    for shortlong = 1
        for block = 4          clearvars -except block600 subject block shortlong
            if shortlong == 1
                short_long = 'Short'; % Long or Short
            else
                short_long = 'long'; % Long or Short
            end

            load (['D:\Sharif\Data\Psycho\',short_long,'_ISI\',short_long,num2str(subject),'\Block-',num2str(block)])  %%% subject

            images = info_block.ImageNumber;
            resp = info_block.SubjectRes;
            real_res = info_block.RealResponse;
            subj_resp = info_block.SubRespTime;
            for i = 1:600
                levels(i) = block600{i,2}; %%% block level
            end
            stimulustime = 30;
            channels = 1:31;

            %% Step (1): Reading the data
            load eegdata

            %%% for all subjects except short 2 , 3
            % x = eegdata;

            %%% for short 2,3 29 ch - Cz for  mean(C3,C4وFCz,CPz)
            x = [eegdata(1:14,:);mean([eegdata(10,:);eegdata(14,:);eegdata(15,:);eegdata(19,:)]);eegdata(15:29,:)];

            %% Step (2): Event capturing
            load eegevent
            events_channel = eegevent;
            k = 0;
            event_time = [];
            stim_window = 100;
            for i = stim_window+1:length(events_channel)
                if events_channel(i)>=20 && sum(events_channel(i-stim_window:i-1)==0)==stim_window
                    k = k+1;
                    event_time(k) = i;
                end
            end
            %% __________________________________ Psycho Analysis ____________________________%%
            %%% Animal/Levels
            for i = 1:length(event_time)
                if images(i)<=300
                    type = 0;           % animals
                elseif images(i)>300
                    type = 1;          % Noanimals
                end
                level_correct_event(i,:) = [event_time(i)./1000 type levels(images(i)) real_res(i) resp(i) subj_resp(i) images(i)];
            end
            save(['events_',lower(short_long),'_subject-',num2str(subject),'-',num2str(block),'.txt'], 'level_correct_event', '-ASCII')
            save(['data_',lower(short_long),'_subject-',num2str(subject),'-',num2str(block),'.mat'],'x');

            [subject shortlong block]
        end
    end
end