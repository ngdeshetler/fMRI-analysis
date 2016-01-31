function LSS_ERS_analysis

SUBS=8:26;
%
ERS=[];
all_data=[];
load('condensed_data.mat')
load('ERS_all.mat')

num_runs=3;


masks={'right_CA1_fixed', 'left_CA1_fixed', 'right_CA23DG_fixed', 'left_CA23DG_fixed', 'right_Sub_fixed', 'left_Sub_fixed',...
    'right_ERC_fixed','left_ERC_fixed','right_PHC_fixed','left_PHC_fixed','right_PRC_fixed','left_Fus_fixed','right_Fus_fixed',...
    'left_hipp','right_hipp','hipp','left_MTL_cortex','right_MTL_cortex','MTL_cortex','left_MTL','right_MTL','MTL',...
    'right_NAcc','left_NAcc','VTA_10','VTA_25','VTA_50','VTA_75','VTA_90','VTA_100'};
masks_names={'RCA1', 'LCA1', 'RCA23DG', 'LCA23DG', 'RSub', 'LSub','RERC','LERC','RPHC','LPHC','RPRC','LFus','RFus',...
    'Lhipp','Rhipp','hipp','LMTL_C','RMTL_C','MTL_C','LMTL','RMTL','MTL','RNAcc','LNAcc','VTA_10','VTA_25','VTA_50','VTA_75','VTA_90','VTA_100'};
%masks_names={'VA_mask_clean_brain','L_CA1_fixed_test','L_CA3DG_fixed_test','L_Sub_fixed_test','R_CA1_fixed_test','R_CA3DG_fixed_test','R_Sub_fixed_test'};
%masks_names_text={'VA','LCA1','LCA3DG','LSub','RCA1','RCA3DG','RSub'};


for g=1:length(SUBS)
    
    sub_ID=sprintf('sub%d',SUBS(g))
    if isfield(ERS,sub_ID)
        for c=1:length(masks)
            if isfield(ERS.(sub_ID),masks_names{c})
                %% All ERS
                repeat_holder=[];
                lure_holder=[];
                new_holder=[];
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        repeat_holder=[repeat_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS];
                        lure_holder=[lure_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS];
                        new_holder=[new_holder ERS.(sub_ID).(masks_names{c}).block(n).new_ERS];
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatAll_ERS=nanmean(repeat_holder);
                ERS.(sub_ID).(masks_names{c}).lureAll_ERS=nanmean(lure_holder);
                ERS.(sub_ID).(masks_names{c}).newAll_ERS=nanmean(new_holder);
                
                %% Remember
                repeat_rem_holder=[];
                lure_rem_holder=[];
                repeat_for_holder=[];
                lure_for_holder=[];
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    c_rep=all_data.(sub_ID).block(n).sub_correct.trials;
                    c_lure=all_data.(sub_ID).block(n).sub_correct_lure.trials;
                    
                    f_rep=setdiff(1:22,c_rep);
                    f_lure=setdiff(1:22,c_lure);
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        repeat_rem_holder=[repeat_rem_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(c_rep)];
                        lure_rem_holder=[lure_rem_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(c_lure)];
                        
                        repeat_for_holder=[repeat_for_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(f_rep)];
                        lure_for_holder=[lure_for_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(f_lure)];
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatR_ERS=nanmean(repeat_rem_holder);
                ERS.(sub_ID).(masks_names{c}).lureR_ERS=nanmean(lure_rem_holder);
                ERS.(sub_ID).(masks_names{c}).repeatF_ERS=nanmean(repeat_for_holder);
                ERS.(sub_ID).(masks_names{c}).lureF_ERS=nanmean(lure_for_holder);
                
                %% Pattern Seperation
                repeat_PS_holder=[];
                lure_PS_holder=[];
                repeat_nPS_holder=[];
                lure_nPS_holder=[];
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    ps_rep=all_data.(sub_ID).block(n).sub_correct_PS.trials;
                    ps_lure=all_data.(sub_ID).block(n).sub_correctLure_PS.trials;
                    
                    nps_rep=all_data.(sub_ID).block(n).sub_correct_nPS.trials;
                    nps_lure=all_data.(sub_ID).block(n).sub_correctLure_nPS.trials;
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        repeat_PS_holder=[repeat_PS_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(ps_rep)];
                        lure_PS_holder=[lure_PS_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(ps_lure)];
                        
                        repeat_nPS_holder=[repeat_nPS_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(nps_rep)];
                        lure_nPS_holder=[lure_nPS_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(nps_lure)];
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatPS_ERS=nanmean(repeat_PS_holder);
                ERS.(sub_ID).(masks_names{c}).lurePS_ERS=nanmean(lure_PS_holder);
                ERS.(sub_ID).(masks_names{c}).repeatNPS_ERS=nanmean(repeat_nPS_holder);
                ERS.(sub_ID).(masks_names{c}).lureNPS_ERS=nanmean(lure_nPS_holder);
                
                %% High low
                repeat_high_holder=[];
                lure_high_holder=[];
                new_high_holder=[];
                repeat_low_holder=[];
                lure_low_holder=[];
                new_low_holder=[];
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    high_v=all_data.(sub_ID).block(n).high_value.trials;
                    low_v=all_data.(sub_ID).block(n).low_value.trials;
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        repeat_high_holder=[repeat_high_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(high_v)];
                        lure_high_holder=[lure_high_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(high_v)];
                        new_high_holder=[new_high_holder ERS.(sub_ID).(masks_names{c}).block(n).new_ERS(high_v)];
                        
                        repeat_low_holder=[repeat_low_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(low_v)];
                        lure_low_holder=[lure_low_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(low_v)];
                        new_low_holder=[new_low_holder ERS.(sub_ID).(masks_names{c}).block(n).new_ERS(low_v)];
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatH_ERS=nanmean(repeat_high_holder);
                ERS.(sub_ID).(masks_names{c}).lureH_ERS=nanmean(lure_high_holder);
                ERS.(sub_ID).(masks_names{c}).newH_ERS=nanmean(new_high_holder);
                ERS.(sub_ID).(masks_names{c}).repeatL_ERS=nanmean(repeat_low_holder);
                ERS.(sub_ID).(masks_names{c}).lureL_ERS=nanmean(lure_low_holder);
                ERS.(sub_ID).(masks_names{c}).newL_ERS=nanmean(new_low_holder);
                
                %% High low ignore item
                repeat_high_holder=[];
                repeat_low_holder=[];
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    high_v=all_data.(sub_ID).block(n).high_value.trials;
                    low_v=all_data.(sub_ID).block(n).low_value.trials;
                    repeat_high_holder_alt=[];
                    repeat_low_holder_alt=[];
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        
                        for y=1:length(high_v)%for ever encoded high value image
                            high_val_matrix=ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS_matrix{high_v(y)}; %its correlation with all repeats
                            high_val_matrix(low_v)=0; %exclude the low value repeats
                            high_val_matrix(high_v(y))=0; %exclude itself
                            repeat_high_holder_alt(y)=nanmean(high_val_matrix(find(high_val_matrix))); %the average of correlation of the high value item with all other high value repeats
                        
                        end
                        repeat_high_holder=[repeat_high_holder repeat_high_holder_alt];
                        
                        for y=1:length(low_v)
                            low_val_matrix=ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS_matrix{low_v(y)};
                            low_val_matrix(high_v)=0;
                            low_val_matrix(low_v(y))=0;
                            repeat_low_holder_alt(y)=nanmean(low_val_matrix(find(low_val_matrix)));
                        end
                        repeat_low_holder=[repeat_low_holder repeat_low_holder_alt];
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatH_ERS_nonI=nanmean(repeat_high_holder);
                ERS.(sub_ID).(masks_names{c}).repeatL_ERS_nonI=nanmean(repeat_low_holder);
                
                %% combo H_L R_F
                repeat_highR_holder=[];
                lure_highR_holder=[];
                repeat_lowR_holder=[];
                lure_lowR_holder=[];
                repeat_highF_holder=[];
                lure_highF_holder=[];
                repeat_lowF_holder=[];
                lure_lowF_holder=[];
                
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    high_v=all_data.(sub_ID).block(n).high_value.trials;
                    low_v=all_data.(sub_ID).block(n).low_value.trials;
                    
                    c_rep=all_data.(sub_ID).block(n).sub_correct.trials;
                    c_lure=all_data.(sub_ID).block(n).sub_correct_lure.trials;
                    
                    f_rep=setdiff(1:22,c_rep);
                    f_lure=setdiff(1:22,c_lure);
                    
                    c_rep_high=c_rep(ismember(c_rep,high_v));
                    c_rep_low=c_rep(ismember(c_rep,low_v));
                    
                    c_lure_high=c_lure(ismember(c_lure,high_v));
                    c_lure_low=c_lure(ismember(c_lure,low_v));
                    
                    f_rep_high=f_rep(ismember(f_rep,high_v));
                    f_rep_low=f_rep(ismember(f_rep,low_v));
                    
                    f_lure_high=f_lure(ismember(f_lure,high_v));
                    f_lure_low=f_lure(ismember(f_lure,low_v));
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        repeat_highR_holder=[repeat_highR_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(c_rep_high)];
                        lure_highR_holder=[lure_highR_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(c_lure_high)];
                        
                        repeat_lowR_holder=[repeat_lowR_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(c_rep_low)];
                        lure_lowR_holder=[lure_lowR_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(c_lure_low)];
                        
                        repeat_highF_holder=[repeat_highF_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(f_rep_high)];
                        lure_highF_holder=[lure_highF_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(f_lure_high)];
                        
                        repeat_lowF_holder=[repeat_lowF_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(f_rep_low)];
                        lure_lowF_holder=[lure_lowF_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(f_lure_low)];
                        
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatH_R_ERS=nanmean(repeat_highR_holder);
                ERS.(sub_ID).(masks_names{c}).lureH_R_ERS=nanmean(lure_highR_holder);
                ERS.(sub_ID).(masks_names{c}).repeatL_R_ERS=nanmean(repeat_lowR_holder);
                ERS.(sub_ID).(masks_names{c}).lureL_R_ERS=nanmean(lure_lowR_holder);
                
                ERS.(sub_ID).(masks_names{c}).repeatH_F_ERS=nanmean(repeat_highF_holder);
                ERS.(sub_ID).(masks_names{c}).lureH_F_ERS=nanmean(lure_highF_holder);
                ERS.(sub_ID).(masks_names{c}).repeatL_F_ERS=nanmean(repeat_lowF_holder);
                ERS.(sub_ID).(masks_names{c}).lureL_F_ERS=nanmean(lure_lowF_holder);
                
                %% combo H_L PS_nPS
                repeat_highPS_holder=[];
                lure_highPS_holder=[];
                repeat_lowPS_holder=[];
                lure_lowPS_holder=[];
                repeat_highNPS_holder=[];
                lure_highNPS_holder=[];
                repeat_lowNPS_holder=[];
                lure_lowNPS_holder=[];
                for n=1:length(ERS.(sub_ID).(masks_names{c}).block)
                    high_v=all_data.(sub_ID).block(n).high_value.trials;
                    low_v=all_data.(sub_ID).block(n).low_value.trials;
                    
                    ps_rep=all_data.(sub_ID).block(n).sub_correct_PS.trials;
                    ps_lure=all_data.(sub_ID).block(n).sub_correctLure_PS.trials;
                    
                    nps_rep=all_data.(sub_ID).block(n).sub_correct_nPS.trials;
                    nps_lure=all_data.(sub_ID).block(n).sub_correctLure_nPS.trials;
                    
                    ps_rep_high=ps_rep(ismember(ps_rep,high_v));
                    ps_rep_low=ps_rep(ismember(ps_rep,low_v));
                    
                    ps_lure_high=ps_lure(ismember(ps_lure,high_v));
                    ps_lure_low=ps_lure(ismember(ps_lure,low_v));
                    
                    nps_rep_high=nps_rep(ismember(nps_rep,high_v));
                    nps_rep_low=nps_rep(ismember(nps_rep,low_v));
                    
                    nps_lure_high=nps_lure(ismember(nps_lure,high_v));
                    nps_lure_low=nps_lure(ismember(nps_lure,low_v));
                    
                    if ~isempty(ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS)
                        repeat_highPS_holder=[repeat_highPS_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(ps_rep_high)];
                        lure_highPS_holder=[lure_highPS_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(ps_lure_high)];
                        
                        repeat_lowPS_holder=[repeat_lowPS_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(ps_rep_low)];
                        lure_lowPS_holder=[lure_lowPS_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(ps_lure_low)];
                        
                        repeat_highNPS_holder=[repeat_highNPS_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(nps_rep_high)];
                        lure_highNPS_holder=[lure_highNPS_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(nps_lure_high)];
                        
                        repeat_lowNPS_holder=[repeat_lowNPS_holder ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(nps_rep_low)];
                        lure_lowNPS_holder=[lure_lowNPS_holder ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(nps_lure_low)];
                        
                    end
                end
                ERS.(sub_ID).(masks_names{c}).repeatH_PS_ERS=nanmean(repeat_highPS_holder);
                ERS.(sub_ID).(masks_names{c}).lureH_PS_ERS=nanmean(lure_highPS_holder);
                ERS.(sub_ID).(masks_names{c}).repeatL_PS_ERS=nanmean(repeat_lowPS_holder);
                ERS.(sub_ID).(masks_names{c}).lureL_PS_ERS=nanmean(lure_lowPS_holder);
                
                ERS.(sub_ID).(masks_names{c}).repeatH_nPS_ERS=nanmean(repeat_highNPS_holder);
                ERS.(sub_ID).(masks_names{c}).lureH_nPS_ERS=nanmean(lure_highNPS_holder);
                ERS.(sub_ID).(masks_names{c}).repeatL_nPS_ERS=nanmean(repeat_lowNPS_holder);
                ERS.(sub_ID).(masks_names{c}).lureL_nPS_ERS=nanmean(lure_lowNPS_holder);
            end
        end
    end
    
    save('ERS_analysis','ERS')
end 