function M = generateMatrix(Z1,Z2,f,v1,l1,v2,l2)
    %Reflection and transmission coefficients
    r12 = (Z1 - Z2)/(Z1 + Z2);
    t12 = 2*Z1/(Z1 + Z2);

    r21 = (Z2 - Z1)/(Z1 + Z2);
    t21 = 2*Z2/(Z1 + Z2);
    
    T12 = 1/t12 * [1 r12; r12 1];
    T21 = 1/t21 * [1 r21; r21 1];
    
    phi1 = 2*pi*f/v1*l1;
    phi2 = 2*pi*f/v2*l2;

    P1 = [exp(1i*phi1) 0; 0 exp(-1i*phi1)];
    P2 = [exp(1i*phi2) 0; 0 exp(-1i*phi2)];

    M = T21*P2*T12*P1;
end