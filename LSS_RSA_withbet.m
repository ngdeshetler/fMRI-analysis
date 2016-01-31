function LSS_RSA_withbet

SUBS=8:26;
%
all_data=[];
load('condensed_data.mat')
RSA=[];
load('RSA_all.mat')


num_runs=3;


%masks={'right_CA1_fixed', 'left_CA1_fixed', 'right_CA23DG_fixed', 'left_CA23DG_fixed', 'right_Sub_fixed', 'left_Sub_fixed',...
%    'right_ERC_fixed','left_ERC_fixed','right_PHC_fixed','left_PHC_fixed','right_PRC_fixed','left_Fus_fixed','right_Fus_fixed'};
%masks_names={'RCA1', 'LCA1', 'RCA23DG', 'LCA23DG', 'RSub', 'LSub','RERC','LERC','RPHC','LPHC','RPRC','LFus','RFus'};
%masks={'left_hipp','right_hipp','hipp','left_MTL_cortex','right_MTL_cortex','MTL_cortex','left_MTL','right_MTL','MTL'};
%masks_names={'Lhipp','Rhipp','hipp','LMTL_C','RMTL_C','MTL_C','LMTL','RMTL','MTL'};

%masks_names={'RCA1', 'LCA1', 'RCA23DG', 'LCA23DG', 'RSub', 'LSub','RERC','LERC','RPHC','LPHC','RPRC','LFus','RFus',...
%    'Lhipp','Rhipp','hipp','LMTL_C','RMTL_C','MTL_C','LMTL','RMTL','MTL'};

masks_names={'VTA_10','VTA_25','VTA_50','VTA_75','VTA_90','VTA_100'};

for g=1:length(SUBS)
    sub_ID=sprintf('sub%d',SUBS(g))
    if isfield(RSA,sub_ID)
        for d=1:length(masks_names)
            if isfield(RSA.(sub_ID),masks_names{d})
                RSA.(sub_ID).(masks_names{d}).within_trials.high_val=[];
                RSA.(sub_ID).(masks_names{d}).within_trials.low_val=[];
                RSA.(sub_ID).(masks_names{d}).within_trials.all_val=[];
                
                RSA.(sub_ID).(masks_names{d}).between_trials.high_val=[];
                RSA.(sub_ID).(masks_names{d}).between_trials.low_val=[];
                RSA.(sub_ID).(masks_names{d}).between_trials.all_val=[];
                for n=1:length(RSA.(sub_ID).(masks_names{d}).encoding_block)
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.high_val=[];
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.low_val=[];
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.all_val=[];
                    
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.high_val=[];
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.low_val=[];
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.all_val=[];
                    
                    for m=1:length(RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial)
                        target_val=all_data.(sub_ID).block(n).learn.trial(m).value_name;
                        within_val_overall=[];
                        between_val_overall=[];
                        for j=1:length(RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block)
                            within_val=[];
                            between_val=[];
                            for t=1:length(RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).trial)
                                trial_val=all_data.(sub_ID).block(j).learn.trial(t).value_name;
                                if strcmp(target_val,trial_val)
                                    within_val=[within_val RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).trial(t)];
                                else
                                    between_val=[between_val RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).trial(t)];
                                end
                            end
                            RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).within_trials=within_val;
                            RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).within_ave=mean(within_val);
                            RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).between_trials=between_val;
                            RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).block(j).between_ave=mean(between_val);
                            if j~=n
                                within_val_overall=[within_val_overall within_val];
                                between_val_overall=[between_val_overall between_val];
                            end
                        end
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).within_trials=within_val_overall;
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).within_ave=mean(within_val_overall);
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).between_trials=between_val_overall;
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).trial(m).between_ave=mean(between_val_overall);
                        
                        
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.all_val=[RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.all_val within_val_overall];
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.all_val=[RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.all_val between_val_overall];
                        
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.(target_val)=[RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.(target_val) within_val_overall];
                        RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.(target_val)=[RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.(target_val) between_val_overall];
                        
                        RSA.(sub_ID).(masks_names{d}).within_trials.all_val=[RSA.(sub_ID).(masks_names{d}).within_trials.all_val within_val_overall];
                        RSA.(sub_ID).(masks_names{d}).between_trials.all_val=[RSA.(sub_ID).(masks_names{d}).between_trials.all_val between_val_overall];
                        
                        RSA.(sub_ID).(masks_names{d}).within_trials.(target_val)=[RSA.(sub_ID).(masks_names{d}).within_trials.(target_val) within_val_overall];
                        RSA.(sub_ID).(masks_names{d}).between_trials.(target_val)=[RSA.(sub_ID).(masks_names{d}).between_trials.(target_val) between_val_overall];
                        
                    end
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_ave.all_val=mean(RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.all_val);
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_ave.all_val=mean(RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.all_val);
                    
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_ave.high_val=mean(RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.high_val);
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_ave.high_val=mean(RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.high_val);
                    
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_ave.low_val=mean(RSA.(sub_ID).(masks_names{d}).encoding_block(n).within_trials.low_val);
                    RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_ave.low_val=mean(RSA.(sub_ID).(masks_names{d}).encoding_block(n).between_trials.low_val);
                    
                end
                RSA.(sub_ID).(masks_names{d}).within_ave.all_val=mean(RSA.(sub_ID).(masks_names{d}).within_trials.all_val);
                RSA.(sub_ID).(masks_names{d}).between_ave.all_val=mean(RSA.(sub_ID).(masks_names{d}).between_trials.all_val);
                
                RSA.(sub_ID).(masks_names{d}).within_ave.high_val=mean(RSA.(sub_ID).(masks_names{d}).within_trials.high_val);
                RSA.(sub_ID).(masks_names{d}).between_ave.high_val=mean(RSA.(sub_ID).(masks_names{d}).between_trials.high_val);
                
                RSA.(sub_ID).(masks_names{d}).within_ave.low_val=mean(RSA.(sub_ID).(masks_names{d}).within_trials.low_val);
                RSA.(sub_ID).(masks_names{d}).between_ave.low_val=mean(RSA.(sub_ID).(masks_names{d}).between_trials.low_val);
            end
        end
    end
end
%RSA.(sub_ID).(masks_names{d}).recall_block(n).trial(m).block(j).trial(t)=holder(2,1);


save('RSA_all','RSA')

end