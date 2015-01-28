function p = particle(varargin)
%PARTICLE.M Particle Object Constructor

p.position = [0 0];
p.color = [1 0 0];
p.path = []; % Travel Path
p = class(p, 'particle');
end

