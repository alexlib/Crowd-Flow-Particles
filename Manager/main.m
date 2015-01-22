function main( input_args )
%MAIN Starts the cycle by genrating a set of particles that are placed atop
%optical flow fields; optical flow fields are post-processed

frame_height = 100;
frame_width = 100;
frame_count = 100;
% Generate a set of particles
particles = {};
no_particles = 10;

%Generate particle starting locations
p_distribution = [rand(10,1) * (frame_height - 1),rand(10,1) * (frame_width - 1)];

for i = 1: no_particles
    particles = add_particle(particles,p_distribution(i,:));
end


h = figure;
axis([1 100 1 100])
axis manual
f = 0;
while f < frame_count
    
    % Generate Optical Flow Fields (Random Here)
    U = rand(frame_height,frame_width); %- rand(frame_height,frame_width);
    V = rand(frame_height,frame_width); %-rand(frame_height,frame_width);
    
    % Apply Smoothing
    [U,V] = mean_flow(U,V);
    % Move Particles
    for i = 1: no_particles
        p = particles{i};
        point = get_position(p);
        
        if (point(1) >= frame_height || point(2) >= frame_width || ...
           point(1) < 1 || point(2) < 1)
            % Point off frame, kill it
        else
            point(1) = point(1) + U(floor(point(1)),floor(point(2)));
            point(2) = point(2) + V(floor(point(1)),floor(point(2)));
        end
        particles{i} = set_position(p,point);
    end
    
    image(U), hold on;
    for i = 1: no_particles
        p = particles{i};
        point = get_position(p);
        scatter(point(1),point(2)); hold on
    end
    
    pause(0.001);
    clf(h);
    axis([1 100 1 100])

    % Increase Frame Counter
    f = f + 1;
end

end

