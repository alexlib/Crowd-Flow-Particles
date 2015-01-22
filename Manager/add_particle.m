function particles = add_particle(varargin )
%ADD_PARTICLE Add Particles
% 1) Current Collection of Particles
% 2) New Particle Position
% 3) Color

if length(varargin) < 2
    error('Too few arguments');
end

position = varargin{2};
particles = varargin{1};

p = particle();
p = set_position(p,position);

particles = [particles, {p}];

end
