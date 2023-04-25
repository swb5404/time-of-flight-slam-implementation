close all
clearvars
clear workspace


%brokerAddress = "tcp://10.0.0.93";
brokerAddress = "tcp://172.20.10.3";
port = 1883;


%mqCommandClient = mqttclient(brokerAddress, Port = port);
%subscribe(mqCommandClient, "commands");
mqClient = mqttclient(brokerAddress, Port = port);
subscribe(mqClient, "distance");
subscribe(mqClient, "xData");
subscribe(mqClient, "yData");
subscribe(mqClient, "zData");





% Read gyroscope data
%xDataTT = read(mqClient,"Topic","xData");
%xData = str2double(xDataTT.Data(1));       % tilt (+ Down, - Up)
%yDataTT = read(mqClient,"Topic","yData");  % Pan (+ CCW)
%yData = str2double(yDataTT.Data(1));
%zDataTT = read(mqClient,"Topic","zData"); % Face Rotate (+ CCW)
%zData = str2double(zDataTT.Data(1));
%distanceTT = read(mqClient,"Topic","distance");
%distance = str2double(distanceTT.Data(1));

theta_x = 0;
theta_y = 0;
theta_z = 0;
xAngle = 0;
yAngle = 0;





dt = 1 / (2 * 250);  % Time step between measurements (in seconds)
       
        
elapsed_time = 1/72;
yCommand = "up";

% Set up the figure window for the 2D image plot
figure(1);

title('Real-Time Distance Plot'); % Set the title of the plot
hold on
xCount = 0;
count = 0;
points = [0,0,0];
% Continuously update the image plot with new data from the sensor
%color = rand(100); % RGB color values for each point
ylabel('Y-axis');
xlabel('X-axis');
zlabel('Z-axis');
grid on
axis equal
set(gca,'color',[0 0 0])

%xlim([-max(distance), max(distance)]);
%ylim([-max(distance), max(distance)]);
%zlim([-max(distance), max(distance)]);

while (true)
    tic
    %72 deg/s
    xAngle = xAngle+(72*elapsed_time);
    
    

    yValid = mod(xCount,3);


    if (xAngle >= 360)
        if (xCount == 3)
            xCount = 0;
            xAngle = xAngle-360;
        else
            xCount = xCount + 1;
             xAngle = xAngle-360;
        end
    end

    if (yValid == 0)
    
        if (-180 < yAngle && yAngle < 180)
            if (yCommand == "up")
                yAngle = yAngle+4.5;
            else
                yAngle = yAngle-4.5;
            end
        
        elseif(yAngle <= -180)
            yAngle = yAngle+4.5;
            yCommand = "up";
        

        elseif(yAngle >= 180)
            yAngle = yAngle-4.5;
            yCommand = "down";
        end
    end


  
         % Read gyroscope data
    %xDataTT = read(mqClient,"Topic","xData");   
    %yDataTT = read(mqClient,"Topic","yData"); % Pan (+ CCW)
    %zDataTT = read(mqClient,"Topic","zData"); % Face Rotate (+ CCW)
    distanceTT = read(mqClient,"Topic","distance");

    % Check if "Data" column is present in xDataTT

    
%if ~ismember("Data", xDataTT.Properties.VariableNames)
  %  continue;
%end

%if ~ismember("Data", yDataTT.Properties.VariableNames)
    %continue;
%end

%if ~ismember("Data", zDataTT.Properties.VariableNames)
 %   continue;
%end

if ~ismember("Data", distanceTT.Properties.VariableNames)
    continue;
end



    %xData = str2double(xDataTT.Data(1));                                    % tilt (+ Down, - Up)
    
    %yData = str2double(yDataTT.Data(1));
  
    %zData = str2double(zDataTT.Data(1));

    distance = str2double(distanceTT.Data(1));
 
    
    %coordinateArray(count,3) = xData;
    %coordinateArray(count,3) = yData;
    %distanceArray(count,3) = distance;
 
    % Assume gyro.data.x contains the angular rate measurement in deg/s
    
    % Integrate the angular rates to get the angles
    %theta_x =  xData * dt;
   % theta_y =  yData * dt;
   % theta_z =  zData * dt;
    
    
    %xCoord = distance .* cos(xAngle);
    %yCoord = distance .* sin(xAngle);
    %zCoord = distance .* sin(yAngle) .* cos(xAngle);

    xCoord = distance .* cosd(yAngle) .* cosd(xAngle);
    yCoord = distance .* cosd(yAngle) .* sind(xAngle);
    zCoord = distance .* sind(yAngle);


 
    d = sqrt(xCoord.^2 + yCoord.^2 + zCoord.^2);
    % Plot the points in 3D space
    
    scatter3(xCoord,yCoord,zCoord,10,d, "filled");
    colorbar
    
    points = [points; xCoord, yCoord, zCoord];

    %cloud = pointCloud(points);
    %cloud = pcmedian(cloud,'Dimensions',3,'Radius',1);
    %if(count >300)
    % figure(2)
     %hold on
     %pcshow(cloud)
   % end
    
    
    count = count + 1;
    mqClient.flush();
    elapsed_time = toc;
  
end



