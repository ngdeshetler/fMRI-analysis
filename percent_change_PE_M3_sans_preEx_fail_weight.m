function percent_change_PE_M3_sans_preEx_fail_weight()

script_path=which('percent_change_PE_M3.m');
script_dirct=fileparts(script_path);
cd(script_dirct);

ROIs={'RCA1', 'LCA1', 'RCA3DG', 'LCA3DG', 'RSub', 'LSub'};
%'RHipp','LHipp',


EVs={'cue','probe_fail','match_succ','foil_succ','mm_succ_pre','mm_succ_non'};
%,'mm_succ'

PVALS={'25','50','20'};
%


SUBS={'507'};
%{'502','503','505','507','508','509','510','511','512','513','514','515','516','517','518','519','520','521','522','523','524','525','526','527','528','529','530'};
%,
%


for j=1:length(PVALS)
    
    %for q=1:length(PARTs)
    
    save_file=sprintf('./data/percentChange_dataPE_M3_sans_preEx_%s_fail_weight.mat',PVALS{j});
    featquery=[];
    load(save_file)
    
    
    for n=1:length(SUBS)
        subject=sprintf('MM_%s',SUBS{n});
        for i=1:8
            DIR=sprintf('%s/analysis/STAT/run%d_output_m3_noSmooth_sans_preEx_weight.feat/stats/extractions',subject,i)
            cd(script_dirct);
            cd('..');
            if exist(DIR,'dir')~=0
                
                cd(DIR);
                ROIs={'RCA1', 'LCA1', 'RCA3DG', 'LCA3DG', 'RSub', 'LSub'};
                
                for h=1:length(ROIs)
                    for k=1:length(EVs)
                        mean_file=sprintf('cope%d_%s_%s_fail_sans_mean.txt', k, ROIs{h},PVALS{j});%PARTs{q},
                        if exist(mean_file,'file')
                            holder=importdata(mean_file);
                            if isempty(holder)~=1
                                featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=holder;
                            else
                                featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=NaN;
                            end
                        else
                            featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=NaN;
                        end
                    end
                end
                %             ROIs={'rightCA1','rightCA3DG','rightSub','rightHead','rightTail','rightERC','rightPHG','leftCA1','leftCA3DG','leftSub','leftHead','leftTail','leftERC','leftPHG'};
                %             for h=1:length(ROIs)
                %                 for k=1:length(EVs)
                %                     mean_file=sprintf('cope%d_%s_%s_fail_mean.txt', k, ROIs{h},PVALS{j});
                %                     if exist(mean_file,'file')
                %                         holder=importdata(mean_file);
                %                         if isempty(holder)~=1
                %                             featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=holder;
                %                         else
                %                             featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=NaN;
                %                         end
                %                     else
                %                         featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=NaN;
                %                     end
                %                 end
                %             end
            end
        end
        %end
    end
    
    %save_file=sprintf('./data/percentChange_dataPE_M3_fix_sans_%s_fail_test.mat',PVALS{j});
    %PARTs{q},
    
    cd(script_dirct);
    save(save_file,'featquery')
    
end


save_file='./data/percentChange_dataPE_M3_sans_preEx_fail_weight.mat';
featquery=[];
load(save_file)


for n=1:length(SUBS)
    subject=sprintf('MM_%s',SUBS{n});
    for i=1:8
        DIR=sprintf('%s/analysis/STAT/run%d_output_m3_noSmooth_sans_preEx_weight.feat/stats/extractions',subject,i)
        cd(script_dirct);
        cd('..');
        if exist(DIR,'dir')~=0
            
            cd(DIR);
            ROIs={'RCA1', 'LCA1', 'RCA3DG', 'LCA3DG', 'RSub', 'LSub'};
            
            for h=1:length(ROIs)
                for k=1:length(EVs)
                    mean_file=sprintf('cope%d_%s_test_mean.txt', k, ROIs{h});%PARTs{q},
                    if exist(mean_file,'file')
                        holder=importdata(mean_file);
                        if isempty(holder)~=1
                            featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=holder;
                        else
                            featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=NaN;
                        end
                    else
                        featquery.(subject).(ROIs{h}).(EVs{k}).mean(i)=NaN;
                    end
                end
            end
            
        end
    end
    %end
end


cd(script_dirct);
save(save_file,'featquery')