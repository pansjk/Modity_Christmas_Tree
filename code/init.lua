-- init.lua    mian
-- morse.lua   file for morsecode showing
-- tree.lua    file for simple show off



r_b = 1 -- HIGH for bright
y_a = 2 -- HIGH for bright
g_a = 3 -- HIGH for bright
y_b = 4 -- HIGH for bright
g_b = 5 -- HIGH for bright
r_a = 7 -- HIGH for bright
morse_led = 6 -- LOW for bright
flag = {1,1,1,1,1,1,1,1} -- 1-on_progress 0-off_progress
duty = {0,0,0,0,0,0,0,0} -- range from 0 to 1000
-------Start Up Init---------
for i=1,7,1 do
    gpio.mode(i, gpio.OUTPUT) 
    tmr.delay(1000)
end
-------IO Check---------
for i=1,7,1 do
    gpio.write(i, gpio.HIGH) --ALL IO HIGH
    tmr.delay(1000)
end
tmr.delay(2000000)
for i=1,7,1 do
    gpio.write(i, gpio.LOW) --ALL IO LOW
end
tmr.delay(2000000)

-------All Led On---------
for i=1,7,1 do
    gpio.write(i, gpio.HIGH) 
    tmr.delay(1000)
end

-------Gpio Pwm Init---------
for i=1,5,1 do
    pwm.setup(i,500,1000)
    tmr.delay(1000)
end
pwm.setup(7,500,1000)
for i=1,5,1 do
    pwm.start(i)
    tmr.delay(1000)
end
pwm.start(7)



local function changeDuty(pin) -- Program for Duty changing,here is 6 seconds for a up down circle. 1s for fast bright 2s slow bright,dark is the same.
    --local duty = pwm.getduty(pin);
    --print("Pin:"..pin);
    --print(duty[pin]);
    
    if(flag[pin] == 1) then 
        if (duty[pin] > 600 and duty[pin] <= 1000 ) then
            duty[pin] = duty[pin] - 8
            pwm.setduty(pin, duty[pin]);
        elseif (duty[pin] >= 6 and duty[pin] <= 600 ) then
            duty[pin] = duty[pin] - 6
            pwm.setduty(pin, duty[pin]);
        else
            flag[pin] = 0;
        end
    else
        if (duty[pin] >= 0 and duty[pin] < 600 ) then
            duty[pin] = duty[pin] + 6
            pwm.setduty(pin, duty[pin] );
        elseif (duty[pin] >= 600 and duty[pin] < 1000 ) then
            duty[pin] = duty[pin] + 8
            pwm.setduty(pin, duty[pin] );
        else
            flag[pin] = 1;
        end
    end
end

local function Blinktop() -- Program for Blink Tips
    gpio.write(morse_led, gpio.LOW)
    tmr.delay(500000)
    gpio.write(morse_led, gpio.HIGH)
    tmr.delay(500000)
end 
function BreathingStart()  -- Program for Start BreathingLED
    tmrra:start()
    tmrrb:start()
    tmrya:start()
    tmryb:start()
    tmrga:start()
    tmrgb:start()
end
function BreathingStop()   -- Program for stop BreathingLED
    tmrra:stop()
    tmrrb:stop()
    tmrya:stop()
    tmryb:stop()
    tmrga:stop()
    tmrgb:stop()
end

tmrra = tmr.create()
tmrra:register(20, tmr.ALARM_AUTO, function() changeDuty(r_a) end)
tmrrb = tmr.create()
tmrrb:register(20, tmr.ALARM_AUTO, function() changeDuty(r_b) end)
tmrya = tmr.create()
tmrya:register(20, tmr.ALARM_AUTO, function() changeDuty(y_a) end)
tmryb = tmr.create()
tmryb:register(20, tmr.ALARM_AUTO, function() changeDuty(y_b) end)
tmrga = tmr.create()
tmrga:register(20, tmr.ALARM_AUTO, function() changeDuty(g_a) end)
tmrgb= tmr.create()
tmrgb:register(20, tmr.ALARM_AUTO, function() changeDuty(g_b) end)


dofile("tree.lua")  -- Doing Simple Showoff


BreathingStart()  -- Begin Breathing

tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()  -- Show Morseclode After 15s
  dofile("morse.lua")
end)
