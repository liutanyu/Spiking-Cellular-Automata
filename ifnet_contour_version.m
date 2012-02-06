%% This program can display the fired neurons of a 2D neural network in 3D 
%% the thired dimenstion is time.



%% Simulation of (leaky) integrate-and-fire neuron
 clear; clf;

%% parameters of the model
 m = 100;                    % there will have m*m neurons
 dt = 0.1;                   % integration time step [ms]
 tau = 10;                   % time constant [ms]
 E_L = -65*ones(m, m);       % resting potential [mV]
 theta = -55;                % firing threshold [mV]
 weight = 13;                % rate is 0.02388
%% make neural network with initial value
   
   X = zeros(m,m);
   % set the initial value using rand()
   p = -1:1;
   for count=1:200,
      kx=floor(rand*(m-4))+2; 
      ky=floor(rand*(m-4))+2; 
      X(kx+p,ky+p)=(rand(3)>0.1);
   end;
   % if the value of X is not 0, the this neuron fired, else set it to -65 in line 48 
   X = (X ~= 0) .* (-55);
   spike = X ~= 0;
   
   contour(X);

   % plot the fire neuron  
 %%  
   % Whether cells stay alive, die, or generate new cells depends
   % upon how many of their eight possible neighbors are alive.
   % Here we generate index vectors for four of the eight neighbors.
   % We use periodic (torus) boundary conditions at the edges of the universe.
   
   n = [m 1:m-1];
   e = [2:m 1];
   s = [2:m 1];
   w = [m 1:m-1];
 
   X = (X ~= 0) .* (-55) + (X == 0) .* (-65); % set the unfired neuron to -65
   
   for t = 1:1:10;
       
      % how many of eight neighbors are fired.
      spike = spike(n,:) + spike(s,:) + spike(:,e) + spike(:,w) + ...
         spike(n,e) + spike(n,w) + spike(s,e) + spike(s,w);
      
      % the fire neuron will generat 80mV current.
      % the NO. of neurons can be stable when the current value is around 150
      
      
      RI_ext = spike .* (12 * weight);
   
      X = X - ((dt/tau) .* ones(m, m)) .* ((X - E_L) - RI_ext);   % if equation
      
      temp1 = X > -55;
      
      X = ~temp1 .* X + temp1 .* -65; % reset 
      
      spike = temp1;    % reset the spike NO. so that spike can indicate which neuron is fired
      
      contour(X);
      drawnow
     

      
   end