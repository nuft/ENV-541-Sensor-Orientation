% Lab 10 pseudocode
% author: Michael Spieler

% initialize x, dx, P, e, W, R, H
for t
    z = get_IMU(t);
    if "Error control"
        z = z + err(e);
    end

    % kinematic motion model using rectangular integration
    % (if trapezoidal or higher order, add z_k-1, z_k-2, ...)
    x1 = ODE_solve(x1, z, dt_INS); 

    if "GPS measurement"
        F = get_F(x1, z); % uses angle a and f1, f2
        G = get_G(x1); % uses angle a
        Phi, Qk = get_Phi_and_Q(F, G, W, dt_KF);

        % prediction step
        dx = Phi*dx;
        P = Phi*P*Phi' + Q;
        % correction step
        dz = get_GPS(t) - p(x1);
        K = P*H'*(H*P*H' + R)^-1;
        dx = dx + K*(dz - H*dx);
        P = (I - K*H)*P;

        e = e + dx2;
        x1 = x1 + dx1;
    end
end