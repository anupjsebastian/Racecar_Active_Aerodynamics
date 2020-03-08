global TurnRight


FLMax = 1;
FRMax = 0;
RLMax = 1;
RRMax = 0;

FLMin = 0.8;
FRMin = 0.2;
RLMin = 0.8;
RRMin = 0.2;

FLRange = FLMax - FLMin ;
FRRange = FRMin - FRMax ;
RLRange = RLMax - RLMin ;
RRRange = RRMin - RRMax ;

if TurnRight == false
    
    
    FLAngle = (8+ WingAngleFrontInner)/28 * FLRange;
    FRAngle = (8+WingAngleFrontOuter)/28 * FRRange;
   RLAngle = (8+WingAngleRearInner)/28 * RLRange ;
    RRAngle = (8+WingAngleRearOuter)/28 * RRRange ;
    
    
    writePosition(FL,0.8+ FLAngle);
    writePosition(FR, 0.2 - FRAngle);
    writePosition(RR,0.2 - RRAngle);
    writePosition(RL,0.8 + RLAngle);

elseif TurnRight == true
    
    FLAngle = (8+ WingAngleFrontOuter)/28 * FLRange;
    FRAngle = (8+WingAngleFrontInner)/28 * FRRange;
    RLAngle = (8+WingAngleRearOuter)/28 * RLRange ;
    RRAngle = (8+WingAngleRearInner)/28 * RRRange ;
    
    
    writePosition(FL,0.8+ FLAngle);
    writePosition(FR, 0.2 - FRAngle);
    writePosition(RR,0.2 - RRAngle);
    writePosition(RL,0.8 + RLAngle);

end