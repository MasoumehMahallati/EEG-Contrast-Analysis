clc;
clear;
% close all;

Subject = 11;
short_long='long';
epoch_wind=[-200:1000];
Data_matrix_total=nan(30,length(epoch_wind),1);
Events_total=nan(1,7);

for block = [1:4]
    % loading data and event files
    data_file=['data_',short_long,'_subject-',num2str(Subject),'-',num2str(block)];
    data = load(data_file);
    
    event_file=['events_',short_long,'_subject-',num2str(Subject),'-',num2str(block),'.txt'];
    events = importdata(event_file);
    events(:,1)=round(events(:,1)*1000);
    
    Preprocessed_data.event=events;   
    %% Epoching
    trial=0;
    EEG_channels_to_keep=[1:30];
    Preprocessed_data.data=data.x(EEG_channels_to_keep,:);
    Data_matrix=nan(length(EEG_channels_to_keep),length(epoch_wind),size(events,1));
    for event = 1:length(events)
        trial = trial+1;
        trial_data = Preprocessed_data.data(:,Preprocessed_data.event(event,1)+epoch_wind(1):Preprocessed_data.event(event,1)+epoch_wind(end));
        Data_matrix(:,1:length(epoch_wind),trial)= trial_data-repmat(nanmean(trial_data(:,1:-epoch_wind(1)),2),[1 length(epoch_wind)]);  %%% baseline correction     
    end
    clearvars Preprocessed_data
    % concatanating all blocks
    Data_matrix_total=cat(3,Data_matrix_total,Data_matrix);
    Events_total=cat(1,Events_total,events);
    [num2str(Subject) ' ' short_long ' ' num2str(block)]
end
Data_matrix_total(:,:,1)=[];
Events_total(1,:)=[];
plot(squeeze(nanmean(Data_matrix_total(1,:,:),3)))
%% Saving
mkdir(['Subject',num2str(Subject,'%02.f'),'_',short_long]);
file_name=['D:\Paper Analysis2\EEG Analysis\Subject',num2str(Subject,'%02.f'),...
    '_',short_long,'\','Subject',num2str(Subject,'%02.f'),'_',short_long,'_preprocessed_data.mat']; %Replaced user with XXXX
save(file_name,'Data_matrix_total','Events_total');
clearvars -except Subject
[Subject]
