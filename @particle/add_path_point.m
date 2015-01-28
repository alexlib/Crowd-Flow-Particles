function [ particle ] = add_path_point( particle,point )
    path = get_path(particle);
    path = [path;point]; 
    particle = set_path(particle,path);
end

