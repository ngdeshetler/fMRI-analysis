function percent_change_PE_weight_withDis()

script_path=which('percent_change_PE_weight_noDis.m');
script_dirct=fileparts(script_path);
cd(script_dirct);

ROIs={'rightCA1', 'leftCA1', 'rightCA23DG', 'leftCA23DG', 'rightSub', 'leftSub'};

SIDE={'P','A'};

EVs={'SubRem_HighVal','SubRem_LowVal','SubFor_HighVal','SubFor_LowVal','SubMis_HighVal','SubMis_LowVal'};
EVs_alt={'SR_HV','SR_LV','SF_HV','SF_LV','SM_HV','SM_LV'};

SUBS={'8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','25'};

featquery=[];
allVariable=[];
save_file=sprintf('./data/percentChange_dataPE_withDis.mat');
load('trial_counts.mat')
load(save_file);

for n=1:length(SUBS)
    subject=['sub',SUBS{n}];
    for h=1:length(ROIs)
        for k=1:length(EVs)
            featquery.(subject).(ROIs{h}).(EVs{k}).weight_mean=nansum(...
                featquery.(subject).(ROIs{h}).(EVs{k}).mean.*allVariable.(subject).(EVs_alt{k}).weight);
        end
    end
end

for n=1:length(SUBS)
    subject=['sub',SUBS{n}];
    for h=1:length(ROIs)
        for j=1:length(SIDE)
        for k=1:length(EVs)
            featquery.(subject).([ROIs{h},'_',SIDE{j}]).(EVs{k}).weight_mean=nansum(...
                featquery.(subject).([ROIs{h},'_',SIDE{j}]).(EVs{k}).mean.*allVariable.(subject).(EVs_alt{k}).weight);
        end
        end
    end
end

save(sprintf('./data/percentChange_dataPE_weighted_withDis.mat'),'featquery')

end