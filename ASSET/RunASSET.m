% ------------------------------------------------------------------------
% AFIT Sensor & Scene Emulation Tool (ASSET)
% ------------------------------------------------------------------------
% DISTRIBUTION C. Distribution authorized to U.S. Government Agencies and
% their contractors; Critical Technology; 07 December 2017. Other request
% for this document shall be referred to AFIT/CTISR, 2950 Hobson Way,
% Wright-Patterson AFB, OH 45433
% ------------------------------------------------------------------------
% Refer to DoD Directive 5230.9 and any applicable security classification 
% guides for guidance on distribution of data and other products generated
% by ASSET prior to distribution
% ------------------------------------------------------------------------
% ASSET and its products are are subject to the terms and conditions of 
% the AFIT Sensor & Scene Emulation Tool (ASSET) License Agreement
% ------------------------------------------------------------------------

% set version:
Version = '1.1 Beta';

% change to ASSET path:
cd(fileparts(which('RunASSET.m')))

% add path to m-files:
addpath(genpath(fullfile(pwd, 'm-files')))
addpath(genpath(fullfile(pwd, 'tools')))
addpath(genpath(fullfile(pwd, 'support')))

if ~exist('cmdline_mode', 'var')

    % In GUI mode ask the user for the path to scenario configuration file:
    [fname,pname] = uigetfile({'*.cfg', 'ASSET Configuration File (*.cfg)'},...
        'Choose configuration file', fullfile(pwd, 'scenario', '*.cfg'), ...
        'multiselect', 'on');
else
    
    % If not in GUI mode (i.e. running from the command line), assume the
    % fname and pname variables are populated:
    assert(exist('pname', 'var') && exist('fname', 'var'), ...
           'Configuration file (fname) and path to configuration file (pname) must be pre-populated (i.e. exist in the base Matlab workspace) in command line mode')
end

% check configuration file
if isequal(fname,0)
    return
end

if ~iscell(fname)
    
    % configuration file location:
    config_path = fullfile(pname, fname);

    % run ASSET:
    if exist('debug','var') && debug == true
        % prior to calling RunASSET create a variable "debug" set equal to 
        %   "true" in the command window (command: "debug = true" without 
        %   quotes) and ASSET will neither catch error statements nor use 
        %   the profiler to time execution:
        profile on
        [Frames, Targets, Geolocation, Noise, Config, Success] = ASSET(config_path);
        profile viewer
    else
        try
            tic
            [Frames, Targets, Geolocation, Noise, Config, Success] = ASSET(config_path);
            toc
        catch ME
            Err.identifier = sprintf('%s',ME.identifier);
            Err.message = sprintf('%s\n\n%s',ME.message, ...
                ['FOR TECHNICAL SUPPORT: send this entire error messsage ' ...
                    '(everything in red) and the configuration (.cfg file) to asset.ctisr@afit.edu']);
            Err.cause = ME.cause;
            Err.stack = ME.stack;
            rethrow(Err)
        end
    end

else

    % Open log file:
    fid = fopen('log.txt','w+');
    
    % Initialize waitbar:
    wbar = waitbar(0,'','Name','ASSET Batch Processing');
    set(wbar,'units','characters')
    wpos = get(wbar,'position');
    set(wbar,'position',[wpos(1) wpos(2)-11/2 wpos(3) 11])
    
    % Loop through selected files:
    ctr = 0;
    nfiles = length(fname);
    err = {};
    for ii = 1 : nfiles
        
        % update waitbar:
        waitbar((ii-0.5)/nfiles,wbar,sprintf( ...
            cat(2,'Executing scenario %d of %d ...\n', ...
            '%d successful\n%d failed\n%d pending\n'), ...
            ii,nfiles,ii-ctr-1,ctr,nfiles-ii))
        drawnow

        % configuration file location:
        config_path = fullfile(pname, fname{ii});

        % check if debugging:
        tic
        if exist('debug','var') && debug == true

            % run ASSET:
            ASSET(config_path,'prompt',false);

            % update log:
            fprintf(fid,'Success: %s\n',config_path);
            fprintf(fid,'  Total elapsed time: %0.0f seconds\n\n',toc);
            
        else
        
            % prevent halting execution on error when running multiple files:
            try
                
                % run ASSET:
                ASSET(config_path,'prompt',false);

                % update log:
                fprintf(fid,'Success: %s\n',config_path);
                fprintf(fid,'  Total elapsed time: %0.0f seconds\n\n',toc);

            catch ME

                % increment error counter:
                ctr = ctr + 1;

                % update log:
                fprintf(fid,'Failed: %s\n\n',config_path);
                fprintf(fid,'   identifier: %s\n',ME.identifier);
                fprintf(fid,'      message: %s\n',ME.message);
                fprintf(fid,'  stack trace: \n\n');
                for jj = 1:length(ME.stack)
                    fprintf(fid,'        file: %s\n',ME.stack(jj).file);
                    fprintf(fid,'        name: %s\n',ME.stack(jj).name);
                    fprintf(fid,'        line: %d\n\n',ME.stack(jj).line);
                end

                try
                    gpuDevice([]);
                end

                err{ctr} = ME;
                cfg{ctr} = fname{ii};
                fprintf('\n\nError in file: %s\n', cfg{ctr})
                
            end

        end
        
    end
    
    % Close log file:
    fclose(fid);
    
    % Close waitbar:
    close(wbar)

    % Display summary:
    fprintf('%d successful and %d failed (see log.txt for more information)\n', ...
        nfiles-ctr,ctr)

    % Print failed configs to screen:
    if ctr ~= 0

        fprintf('\nThe following configurations did not execute successfully:\n')

        for ii = 1 : ctr

            fprintf('  %s\n', cfg{ii})

        end

        fprintf('\n')

    end
    
end

