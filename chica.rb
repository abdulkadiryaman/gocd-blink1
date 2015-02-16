require 'chicanery/cctray'
require 'blink1'

include Chicanery::Cctray

cctray 'go', 'http://go.mycompany.com/go/cctray.xml'

poll_period 5


LIGHTS = {
       'SUCCESS' => [0, 231, 0],
       'FAILURE' => [255, 0, 0]
}

SUCCESS = "SUCCESS"
FAILURE = "FAILURE"

blink1 = Blink1.new

when_run do |state|
  state[:servers]["go"].delete_if { |v|
    !(v.include? "someProject" or
       v.include? "OtherProject")
    }
  if state.has_failure?
     blink1.open
     blink1.set_rgb(*LIGHTS[FAILURE])
     blink1.close
  else
     blink1.open
     blink1.set_rgb(*LIGHTS[SUCCESS])
     blink1.close
  end
  puts state.has_failure? ? "something is wrong" : "all builds are fine"
end
