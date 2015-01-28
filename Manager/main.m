function main
%MAIN Starts the cycle by genrating a set of particles that are placed atop
%optical flow fields; optical flow fields are post-processed
clear all;
clear in;
in.movieType = 'Street4.avi'
vidObj = VideoReader('Street4.avi');
in.method = 'Fullflow1';  
in.bFineScale = 1 ;
in.tIntegration = 0.25;

frame_height = vidObj.height;
frame_width = vidObj.width;
frame_count = 1000;
% Generate a set of particles
particles = {};
no_particles = 200;

%Generate particle starting locations
p_distribution = [rand(no_particles,1) * (frame_height - 1),rand(no_particles,1) * (frame_width - 1)];

for i = 1: no_particles
    particles = add_particle(particles,p_distribution(i,:));
end


h = figure;
   % axis([1 frame_height 1 frame_width])
axis manual

buffer_length = 5;
VBuffer = cell(1,buffer_length);
UBuffer = cell(1,buffer_length);

f = buffer_length + 1;
% Fill Buffer
curIm = generateFrame(vidObj, 1,'file',1);
[dx, dy, dt] = grad3D(curIm,in.bFineScale,1);

% for i = 1: buffer_length
%     curIm = generateFrame(vidObj, i + 1,'file',1);
%     [dx, dy, dt] = grad3D(curIm,in.bFineScale);
%     [UBuffer{i}, VBuffer{i}] = DoFlow1Full(dx,dy,dt,in.tIntegration);
% end

U = 0; V = 0;
colormap('gray')
f = 2;
while f < frame_count
    
    % Generate Optical Flow Fields (Random Here)
    %U = rand(frame_height,frame_width); %- rand(frame_height,frame_width);
    %V = rand(frame_height,frame_width); %-rand(frame_height,frame_width);
    
    curIm = generateFrame(vidObj, f,'file',1);
   
    [dx, dy, dt] = grad3D(curIm,in.bFineScale);
     
    [U, V] = DoFlow1Full(dx,dy,dt,in.tIntegration);
    U = U * 16 ;
    V = V * 16;
    % Here are the Flows U,V; Now
    checkFlowOutput(U, V);%sanity check on flow       


    % Apply Smoothing
    [U,V] = mean_flow(U,V);
    % Move Particles
    parfor i = 1: no_particles
        p = particles{i};
        oldpoint = get_position(p);
        newpoint = oldpoint;
        oldpoint = floor(oldpoint);
        
        if (oldpoint(1) >= frame_height || oldpoint(2) >= frame_width || ...
           oldpoint(1) <=0 || oldpoint(2) <= 0)
            % Point off frame, kill it
            particles{i} = [];
        else
            newpoint(1) = newpoint(1) + V(oldpoint(1),oldpoint(2));
            newpoint(2) = newpoint(2) + U(oldpoint(1),oldpoint(2));
            p = add_path_point(p,newpoint);
        end
        particles{i} = set_position(p,newpoint);
    end
    
    image(vidObj.read(f)), hold on;
     for i = 1: no_particles
         p = particles{i};
         path = get_path(p);
         plot(path(:,2),path(:,1))
         point = get_position(p);
         scatter(point(2),point(1)); 
     end
    hold off;
    pause(0.001);
    %clf(h);
   % axis([1 frame_height 1 frame_width])

    % Increase Frame Counter
    f = f + 1;
end

end

