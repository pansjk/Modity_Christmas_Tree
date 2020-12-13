local morse_code = "1010 1100 011"  -- Editting morsecode here,1 is "ta",0 is "di",a space between letter  
local t = 1000000
local function morsecode_di() -- Program for "di"
    gpio.write(morse_led, gpio.LOW)
    tmr.delay(t)
    
    gpio.write(morse_led, gpio.HIGH)
    tmr.delay(t)
end 

local function morsecode_ta() -- Program for "ta"
    gpio.write(morse_led, gpio.LOW)
    tmr.delay(3*t)
    
    gpio.write(morse_led, gpio.HIGH)
    tmr.delay(t)
end 

local function morsecode_next()  -- Program for next letter
    gpio.write(morse_led, gpio.HIGH)
    tmr.delay(3*t)
end

-- Make sure all led closed
gpio.write(morse_led,gpio.HIGH)
pwm.setduty(r_a, 0) 
pwm.setduty(r_b, 0)
pwm.setduty(g_a, 0)
pwm.setduty(g_b, 0)
pwm.setduty(y_a, 0)
pwm.setduty(y_b, 0)

tmr.delay(8*t)  -- Begin after 8 seconds

BreathingStop()  -- Program for stop BreathingLED form init.lua
gpio.write(morse_led,gpio.HIGH)

for i=1,#morse_code do
    print(string.sub(morse_code,i,i))
    if string.sub(morse_code,i,i) == "0" then
        morsecode_di()
        print("morsecode_di")
    elseif string.sub(morse_code,i,i) == "1" then
        morsecode_ta()
        print("morsecode_ta")
    elseif string.sub(morse_code,i,i) == " " then
        morsecode_next()
        print("morsecode_next")
    end
end

BreathingStart()  -- Program for Start BreathingLED form init.lua

--local blink = 0
--morseledblink = tmr.create()
--morseledblink:register(500, tmr.ALARM_AUTO, function()
--  if blink == 0 then
--    gpio.write(morse_led,gpio.LOW)
--    blink = 1
--  elseif blink == 1 then
--    gpio.write(morse_led,gpio.HIGH)
--    blink = 0
--  end
--end)
--morseledblink:start()
