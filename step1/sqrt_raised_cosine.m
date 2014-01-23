function [srrc_normalized_response] = sqrt_raised_cosine(overSampleFactor, rollOffFactor,limits,Ts)


t = -limits:1/overSampleFactor:limits;
response = zeros(1,length(t));

for i=1:length(t)
   
    if (t(i) == 0)
        response(i) = 1 - rollOffFactor + 4*rollOffFactor/pi;
    elseif (t(i)== Ts/(4*rollOffFactor) || t(i)== -Ts/(4*rollOffFactor))
        response(i) = (rollOffFactor/sqrt(2))*((1+2/pi)*sin(pi/(4*rollOffFactor)) + (1- 2/pi)*cos(pi/(4*rollOffFactor)));
    else
       response(i) = (sin((pi*t(i)/Ts)*(1-rollOffFactor)) + 4*rollOffFactor*(t(i)/Ts)*cos(pi*(t(i)/Ts)*(1+rollOffFactor)))/(pi*(t(i)/Ts)*(1-(4*rollOffFactor*t(i)/Ts)^2)); 
    end
    
    %normalize to unit energy
    srrc_normalized_response = response./sqrt(sum(response.^2));
end

end

