require_relative 'spec_helper.rb'
require 'hue_switch'

describe "Switch" do
	context "user not authorized" do
		it "raises an error" do
			class SwitchTest < Switch
				def initialize
					@user = "043658A90"
					@ip = HTTParty.get("https://www.meethue.com/api/nupnp").first["internalipaddress"]
					unless HTTParty.get("http://#{@ip}/api/#{@user}/config").include?("whitelist")
						if HTTParty.post("http://#{@ip}/api", :body => ({:devicetype => "Hue_Switch", :username=>"1234567890"}).to_json).first.include?("error")
							raise "You need to press the link button on the bridge and run again"
						end
					end
				end
			end
			expect{SwitchTest.new}.to raise_error(RuntimeError)
		end
	end

	context "new Switch without parameters" do
		it "creates a new Switch" do
			Switch.new.class.should == Switch
		end

		it "turns on all lights" do
			result = Switch.new { on }
			result.body == {:on=>true}
		end 

		it "turns off all lights" do
			result = Switch.new { off }
			result.body == {:on=>false}
		end

		it "assigns a color to all lights" do
			result = Switch.new { color :blue}
			result.body == {:hue=>46920}
		end

		it "takes multiple parameters" do
			result = Switch.new { color :reading ; brightness 127 ; on }
			result.body = {:ct=>346, :bri=>127, :on=>true}
		end
	end

	context "Existing switch" do
		before(:all) do
			@switch = Switch.new
			@lights = @switch.instance_variable_get(:@lights)
		end

		it "controls a light group" do
			groups = @switch.instance_variable_get(:@groups).keys
			@switch.lights groups[rand(groups.length)].to_sym
			@switch.on
			@switch.body.should eq ({:on=>true})
		end

		it "controls a single light" do
			@light1 = @lights.keys[rand(@lights.length)].to_sym
			@switch.light @light1
			@switch.lights_array.should eq [@lights[@light1.to_s]]
		end

		it "controls multiple lights" do
			light1 = @lights.keys.first.to_sym
			light2 = @lights.keys[rand(1..@lights.length)].to_sym
			@switch.light light1, light2
			@switch.lights_array.should eq [@lights[light1.to_s], @lights[light2.to_s]]
		end

		it "sets named attributes" do
			@switch.color :blue
			@switch.body[:hue].should eq 46920
		end

		it "set numeric attribues" do
			@switch.hue 50000
			@switch.body[:hue].should eq 50000
		end

		it "schedules lights" do
			result  = @switch.schedule :off, "in 1 minute"
			result.should eq [{"success"=>{"/groups/0/action/alert"=>"select"}}]
		end

		it "deletes schedules" do
			result = @switch.delete_schedules!
			result.should be_empty
		end

		it "takes a string as parameter" do
			@switch.voice "#{@light1} light color neutral brightness ten saturation five"
			@switch.body.should eq ({:ct=>300, :bri=>255, :sat=>127, :on=>true})
		end
	end
end