classdef iter_algo_mgr < handle
    %   Iterative algorithm manager
    %   Track iterative algorithms in a consistent manner
    
    properties
        n_steps         % number of steps taken so far
        track_interval  % how often to track
        time_elapsed    % time_elapsed in the solve phase
        
        tracked_qty     % tracked quantities
        tracked_time    % tracked time
        
        algo_params     % contains algorithmic parameters such as the step_size, decay ratio, etc
    end
    
    methods
        function obj = iter_algo_mgr()
            obj.n_steps = 0;
            obj.time_elapsed = 0;
            obj.track_interval = 0;
            obj.tracked_qty = containers.Map;
            obj.tracked_time = containers.Map;
            obj.algo_params = containers.Map;
        end
        
        function output = do_track(obj)
            if ~obj.track_interval
                output = 0;
            else
                output = ~mod(obj.n_steps, obj.track_interval);
            end
        end
        
        function start_timer(~)
            tic;
        end
        
        function stop_timer(obj)
            obj.time_elapsed = obj.time_elapsed + toc;
        end
        
        
        function record_qty(obj,qty_name, qty_val)
            if ~obj.tracked_qty.isKey(qty_name)
                obj.tracked_qty(qty_name) = [];
                obj.tracked_time(qty_name) = [];
            end
            obj.tracked_qty(qty_name) = [obj.tracked_qty(qty_name), qty_val];
            obj.tracked_time(qty_name) = [obj.tracked_time(qty_name), obj.time_elapsed];
        end
        
    end
end

